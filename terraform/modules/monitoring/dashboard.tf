# =============================================================================
# MONITORING MODULE - Dashboard
# =============================================================================
# Dashboard Cloud Run complet avec :
# - Uptime status
# - Request count & error rate
# - Latency (p50, p95, p99)
# - CPU & Memory utilization
# - Instance count
# - Suspicious requests
# =============================================================================

resource "google_monitoring_dashboard" "cloud_run" {
  project        = var.gcp_project_id
  dashboard_json = jsonencode({
    displayName = "${var.project_name} - ${upper(var.environment)} Monitoring Dashboard"
    
    mosaicLayout = {
      columns = 12
      tiles = concat(
        # =====================================================================
        # ROW 1: Uptime Status (one tile per monitored URL)
        # =====================================================================
        [for idx, url in var.monitored_urls : {
          xPos   = idx * (12 / length(var.monitored_urls))
          yPos   = 0
          width  = 12 / length(var.monitored_urls)
          height = 4
          widget = {
            title = "Uptime - ${url.display_name}"
            scorecard = {
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.labels.check_id = \"${google_monitoring_uptime_check_config.https[url.display_name].uptime_check_id}\""
                  aggregation = {
                    alignmentPeriod  = "300s"
                    perSeriesAligner = "ALIGN_FRACTION_TRUE"
                  }
                }
              }
              thresholds = [
                {
                  value     = 0.99
                  color     = "YELLOW"
                  direction = "BELOW"
                  label     = "Degraded"
                }
              ]
            }
          }
        }],

        # =====================================================================
        # ROW 2: Request Count & Error Rate
        # =====================================================================
        [
          {
            xPos   = 0
            yPos   = 4
            width  = 6
            height = 4
            widget = {
              title = "Request Count (by response code)"
              xyChart = {
                dataSets = [
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/request_count\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_RATE"
                          crossSeriesReducer = "REDUCE_SUM"
                          groupByFields      = ["metric.labels.response_code_class"]
                        }
                      }
                    }
                    plotType   = "STACKED_BAR"
                    legendTemplate = "$${metric.labels.response_code_class}"
                  }
                ]
                yAxis = {
                  label = "Requests/sec"
                  scale = "LINEAR"
                }
                chartOptions = {
                  mode = "COLOR"
                }
              }
            }
          },
          {
            xPos   = 6
            yPos   = 4
            width  = 6
            height = 4
            widget = {
              title = "Error Rate (4xx & 5xx)"
              xyChart = {
                dataSets = [
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/request_count\" AND metric.labels.response_code_class = \"5xx\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_RATE"
                          crossSeriesReducer = "REDUCE_SUM"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "5xx Errors"
                  },
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/request_count\" AND metric.labels.response_code_class = \"4xx\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_RATE"
                          crossSeriesReducer = "REDUCE_SUM"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "4xx Errors"
                  }
                ]
                yAxis = {
                  label = "Errors/sec"
                  scale = "LINEAR"
                }
              }
            }
          }
        ],

        # =====================================================================
        # ROW 3: Latency & Instance Count
        # =====================================================================
        [
          {
            xPos   = 0
            yPos   = 8
            width  = 6
            height = 4
            widget = {
              title = "Request Latency (p50, p95, p99)"
              xyChart = {
                dataSets = [
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/request_latencies\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_PERCENTILE_50"
                          crossSeriesReducer = "REDUCE_MAX"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "p50"
                  },
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/request_latencies\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_PERCENTILE_95"
                          crossSeriesReducer = "REDUCE_MAX"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "p95"
                  },
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/request_latencies\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_PERCENTILE_99"
                          crossSeriesReducer = "REDUCE_MAX"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "p99"
                  }
                ]
                yAxis = {
                  label = "Latency (ms)"
                  scale = "LINEAR"
                }
              }
            }
          },
          {
            xPos   = 6
            yPos   = 8
            width  = 6
            height = 4
            widget = {
              title = "Instance Count"
              xyChart = {
                dataSets = [
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/container/instance_count\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_MAX"
                          crossSeriesReducer = "REDUCE_SUM"
                        }
                      }
                    }
                    plotType   = "STACKED_AREA"
                    legendTemplate = "Instances"
                  }
                ]
                yAxis = {
                  label = "Instances"
                  scale = "LINEAR"
                }
              }
            }
          }
        ],

        # =====================================================================
        # ROW 4: CPU & Memory Utilization
        # =====================================================================
        [
          {
            xPos   = 0
            yPos   = 12
            width  = 6
            height = 4
            widget = {
              title = "CPU Utilization"
              xyChart = {
                dataSets = [
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/container/cpu/utilizations\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_PERCENTILE_99"
                          crossSeriesReducer = "REDUCE_MAX"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "CPU p99"
                  },
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/container/cpu/utilizations\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_MEAN"
                          crossSeriesReducer = "REDUCE_MEAN"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "CPU avg"
                  }
                ]
                yAxis = {
                  label = "Utilization"
                  scale = "LINEAR"
                }
              }
            }
          },
          {
            xPos   = 6
            yPos   = 12
            width  = 6
            height = 4
            widget = {
              title = "Memory Utilization"
              xyChart = {
                dataSets = [
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/container/memory/utilizations\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_PERCENTILE_99"
                          crossSeriesReducer = "REDUCE_MAX"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "Memory p99"
                  },
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND resource.labels.service_name = \"${var.cloud_run_service_name}\" AND metric.type = \"run.googleapis.com/container/memory/utilizations\""
                        aggregation = {
                          alignmentPeriod    = "60s"
                          perSeriesAligner   = "ALIGN_MEAN"
                          crossSeriesReducer = "REDUCE_MEAN"
                        }
                      }
                    }
                    plotType   = "LINE"
                    legendTemplate = "Memory avg"
                  }
                ]
                yAxis = {
                  label = "Utilization"
                  scale = "LINEAR"
                }
              }
            }
          }
        ],

        # =====================================================================
        # ROW 5: Security - Suspicious Requests
        # =====================================================================
        var.enable_log_alerts ? [
          {
            xPos   = 0
            yPos   = 16
            width  = 12
            height = 4
            widget = {
              title = "Suspicious Requests (Attack Detection)"
              xyChart = {
                dataSets = [
                  {
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        filter = "resource.type = \"cloud_run_revision\" AND metric.type = \"logging.googleapis.com/user/${google_logging_metric.suspicious_requests[0].name}\""
                        aggregation = {
                          alignmentPeriod    = "300s"
                          perSeriesAligner   = "ALIGN_SUM"
                          crossSeriesReducer = "REDUCE_SUM"
                        }
                      }
                    }
                    plotType   = "STACKED_BAR"
                    legendTemplate = "Suspicious Requests"
                  }
                ]
                yAxis = {
                  label = "Count"
                  scale = "LINEAR"
                }
              }
            }
          }
        ] : []
      )
    }
  })
}
