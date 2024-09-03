// This file is generated, do not manually edit.
{
  '#': { help: 'grafonnet.panel.xyChart', name: 'xyChart' },
  '#withScatterFieldConfig': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
  withScatterFieldConfig(value): {
    ScatterFieldConfig: value,
  },
  '#withScatterFieldConfigMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
  withScatterFieldConfigMixin(value): {
    ScatterFieldConfig+: value,
  },
  ScatterFieldConfig+:
    {
      '#withHideFrom': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withHideFrom(value): {
        ScatterFieldConfig+: {
          hideFrom: value,
        },
      },
      '#withHideFromMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withHideFromMixin(value): {
        ScatterFieldConfig+: {
          hideFrom+: value,
        },
      },
      hideFrom+:
        {
          '#withLegend': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withLegend(value=true): {
            ScatterFieldConfig+: {
              hideFrom+: {
                legend: value,
              },
            },
          },
          '#withTooltip': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withTooltip(value=true): {
            ScatterFieldConfig+: {
              hideFrom+: {
                tooltip: value,
              },
            },
          },
          '#withViz': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withViz(value=true): {
            ScatterFieldConfig+: {
              hideFrom+: {
                viz: value,
              },
            },
          },
        },
      '#withAxisCenteredZero': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
      withAxisCenteredZero(value=true): {
        ScatterFieldConfig+: {
          axisCenteredZero: value,
        },
      },
      '#withAxisColorMode': { 'function': { args: [{ default: null, enums: ['text', 'series'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
      withAxisColorMode(value): {
        ScatterFieldConfig+: {
          axisColorMode: value,
        },
      },
      '#withAxisGridShow': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
      withAxisGridShow(value=true): {
        ScatterFieldConfig+: {
          axisGridShow: value,
        },
      },
      '#withAxisLabel': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withAxisLabel(value): {
        ScatterFieldConfig+: {
          axisLabel: value,
        },
      },
      '#withAxisPlacement': { 'function': { args: [{ default: null, enums: ['auto', 'top', 'right', 'bottom', 'left', 'hidden'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
      withAxisPlacement(value): {
        ScatterFieldConfig+: {
          axisPlacement: value,
        },
      },
      '#withAxisSoftMax': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
      withAxisSoftMax(value): {
        ScatterFieldConfig+: {
          axisSoftMax: value,
        },
      },
      '#withAxisSoftMin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
      withAxisSoftMin(value): {
        ScatterFieldConfig+: {
          axisSoftMin: value,
        },
      },
      '#withAxisWidth': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
      withAxisWidth(value): {
        ScatterFieldConfig+: {
          axisWidth: value,
        },
      },
      '#withScaleDistribution': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withScaleDistribution(value): {
        ScatterFieldConfig+: {
          scaleDistribution: value,
        },
      },
      '#withScaleDistributionMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withScaleDistributionMixin(value): {
        ScatterFieldConfig+: {
          scaleDistribution+: value,
        },
      },
      scaleDistribution+:
        {
          '#withLinearThreshold': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withLinearThreshold(value): {
            ScatterFieldConfig+: {
              scaleDistribution+: {
                linearThreshold: value,
              },
            },
          },
          '#withLog': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withLog(value): {
            ScatterFieldConfig+: {
              scaleDistribution+: {
                log: value,
              },
            },
          },
          '#withType': { 'function': { args: [{ default: null, enums: ['linear', 'log', 'ordinal', 'symlog'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
          withType(value): {
            ScatterFieldConfig+: {
              scaleDistribution+: {
                type: value,
              },
            },
          },
        },
      '#withLabel': { 'function': { args: [{ default: null, enums: ['auto', 'never', 'always'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
      withLabel(value): {
        ScatterFieldConfig+: {
          label: value,
        },
      },
      '#withLabelValue': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLabelValue(value): {
        ScatterFieldConfig+: {
          labelValue: value,
        },
      },
      '#withLabelValueMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLabelValueMixin(value): {
        ScatterFieldConfig+: {
          labelValue+: value,
        },
      },
      labelValue+:
        {
          '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
          withField(value): {
            ScatterFieldConfig+: {
              labelValue+: {
                field: value,
              },
            },
          },
          '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withFixed(value): {
            ScatterFieldConfig+: {
              labelValue+: {
                fixed: value,
              },
            },
          },
          '#withMode': { 'function': { args: [{ default: null, enums: ['fixed', 'field', 'template'], name: 'value', type: ['string'] }], help: '' } },
          withMode(value): {
            ScatterFieldConfig+: {
              labelValue+: {
                mode: value,
              },
            },
          },
        },
      '#withLineColor': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLineColor(value): {
        ScatterFieldConfig+: {
          lineColor: value,
        },
      },
      '#withLineColorMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLineColorMixin(value): {
        ScatterFieldConfig+: {
          lineColor+: value,
        },
      },
      lineColor+:
        {
          '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
          withField(value): {
            ScatterFieldConfig+: {
              lineColor+: {
                field: value,
              },
            },
          },
          '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withFixed(value): {
            ScatterFieldConfig+: {
              lineColor+: {
                fixed: value,
              },
            },
          },
        },
      '#withLineStyle': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withLineStyle(value): {
        ScatterFieldConfig+: {
          lineStyle: value,
        },
      },
      '#withLineStyleMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withLineStyleMixin(value): {
        ScatterFieldConfig+: {
          lineStyle+: value,
        },
      },
      lineStyle+:
        {
          '#withDash': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withDash(value): {
            ScatterFieldConfig+: {
              lineStyle+: {
                dash:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withDashMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withDashMixin(value): {
            ScatterFieldConfig+: {
              lineStyle+: {
                dash+:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withFill': { 'function': { args: [{ default: null, enums: ['solid', 'dash', 'dot', 'square'], name: 'value', type: ['string'] }], help: '' } },
          withFill(value): {
            ScatterFieldConfig+: {
              lineStyle+: {
                fill: value,
              },
            },
          },
        },
      '#withLineWidth': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['integer'] }], help: '' } },
      withLineWidth(value): {
        ScatterFieldConfig+: {
          lineWidth: value,
        },
      },
      '#withPointColor': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withPointColor(value): {
        ScatterFieldConfig+: {
          pointColor: value,
        },
      },
      '#withPointColorMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withPointColorMixin(value): {
        ScatterFieldConfig+: {
          pointColor+: value,
        },
      },
      pointColor+:
        {
          '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
          withField(value): {
            ScatterFieldConfig+: {
              pointColor+: {
                field: value,
              },
            },
          },
          '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withFixed(value): {
            ScatterFieldConfig+: {
              pointColor+: {
                fixed: value,
              },
            },
          },
        },
      '#withPointSize': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withPointSize(value): {
        ScatterFieldConfig+: {
          pointSize: value,
        },
      },
      '#withPointSizeMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withPointSizeMixin(value): {
        ScatterFieldConfig+: {
          pointSize+: value,
        },
      },
      pointSize+:
        {
          '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
          withField(value): {
            ScatterFieldConfig+: {
              pointSize+: {
                field: value,
              },
            },
          },
          '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withFixed(value): {
            ScatterFieldConfig+: {
              pointSize+: {
                fixed: value,
              },
            },
          },
          '#withMax': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withMax(value): {
            ScatterFieldConfig+: {
              pointSize+: {
                max: value,
              },
            },
          },
          '#withMin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withMin(value): {
            ScatterFieldConfig+: {
              pointSize+: {
                min: value,
              },
            },
          },
          '#withMode': { 'function': { args: [{ default: null, enums: ['linear', 'quad'], name: 'value', type: ['string'] }], help: '' } },
          withMode(value): {
            ScatterFieldConfig+: {
              pointSize+: {
                mode: value,
              },
            },
          },
        },
      '#withShow': { 'function': { args: [{ default: null, enums: ['points', 'lines', 'points+lines'], name: 'value', type: ['string'] }], help: '' } },
      withShow(value): {
        ScatterFieldConfig+: {
          show: value,
        },
      },
    },
  '#withScatterSeriesConfig': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
  withScatterSeriesConfig(value): {
    ScatterSeriesConfig: value,
  },
  '#withScatterSeriesConfigMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
  withScatterSeriesConfigMixin(value): {
    ScatterSeriesConfig+: value,
  },
  ScatterSeriesConfig+:
    {
      '#withHideFrom': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withHideFrom(value): {
        ScatterSeriesConfig+: {
          hideFrom: value,
        },
      },
      '#withHideFromMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withHideFromMixin(value): {
        ScatterSeriesConfig+: {
          hideFrom+: value,
        },
      },
      hideFrom+:
        {
          '#withLegend': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withLegend(value=true): {
            ScatterSeriesConfig+: {
              hideFrom+: {
                legend: value,
              },
            },
          },
          '#withTooltip': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withTooltip(value=true): {
            ScatterSeriesConfig+: {
              hideFrom+: {
                tooltip: value,
              },
            },
          },
          '#withViz': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withViz(value=true): {
            ScatterSeriesConfig+: {
              hideFrom+: {
                viz: value,
              },
            },
          },
        },
      '#withAxisCenteredZero': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
      withAxisCenteredZero(value=true): {
        ScatterSeriesConfig+: {
          axisCenteredZero: value,
        },
      },
      '#withAxisColorMode': { 'function': { args: [{ default: null, enums: ['text', 'series'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
      withAxisColorMode(value): {
        ScatterSeriesConfig+: {
          axisColorMode: value,
        },
      },
      '#withAxisGridShow': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
      withAxisGridShow(value=true): {
        ScatterSeriesConfig+: {
          axisGridShow: value,
        },
      },
      '#withAxisLabel': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withAxisLabel(value): {
        ScatterSeriesConfig+: {
          axisLabel: value,
        },
      },
      '#withAxisPlacement': { 'function': { args: [{ default: null, enums: ['auto', 'top', 'right', 'bottom', 'left', 'hidden'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
      withAxisPlacement(value): {
        ScatterSeriesConfig+: {
          axisPlacement: value,
        },
      },
      '#withAxisSoftMax': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
      withAxisSoftMax(value): {
        ScatterSeriesConfig+: {
          axisSoftMax: value,
        },
      },
      '#withAxisSoftMin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
      withAxisSoftMin(value): {
        ScatterSeriesConfig+: {
          axisSoftMin: value,
        },
      },
      '#withAxisWidth': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
      withAxisWidth(value): {
        ScatterSeriesConfig+: {
          axisWidth: value,
        },
      },
      '#withScaleDistribution': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withScaleDistribution(value): {
        ScatterSeriesConfig+: {
          scaleDistribution: value,
        },
      },
      '#withScaleDistributionMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withScaleDistributionMixin(value): {
        ScatterSeriesConfig+: {
          scaleDistribution+: value,
        },
      },
      scaleDistribution+:
        {
          '#withLinearThreshold': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withLinearThreshold(value): {
            ScatterSeriesConfig+: {
              scaleDistribution+: {
                linearThreshold: value,
              },
            },
          },
          '#withLog': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withLog(value): {
            ScatterSeriesConfig+: {
              scaleDistribution+: {
                log: value,
              },
            },
          },
          '#withType': { 'function': { args: [{ default: null, enums: ['linear', 'log', 'ordinal', 'symlog'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
          withType(value): {
            ScatterSeriesConfig+: {
              scaleDistribution+: {
                type: value,
              },
            },
          },
        },
      '#withLabel': { 'function': { args: [{ default: null, enums: ['auto', 'never', 'always'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
      withLabel(value): {
        ScatterSeriesConfig+: {
          label: value,
        },
      },
      '#withLabelValue': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLabelValue(value): {
        ScatterSeriesConfig+: {
          labelValue: value,
        },
      },
      '#withLabelValueMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLabelValueMixin(value): {
        ScatterSeriesConfig+: {
          labelValue+: value,
        },
      },
      labelValue+:
        {
          '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
          withField(value): {
            ScatterSeriesConfig+: {
              labelValue+: {
                field: value,
              },
            },
          },
          '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withFixed(value): {
            ScatterSeriesConfig+: {
              labelValue+: {
                fixed: value,
              },
            },
          },
          '#withMode': { 'function': { args: [{ default: null, enums: ['fixed', 'field', 'template'], name: 'value', type: ['string'] }], help: '' } },
          withMode(value): {
            ScatterSeriesConfig+: {
              labelValue+: {
                mode: value,
              },
            },
          },
        },
      '#withLineColor': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLineColor(value): {
        ScatterSeriesConfig+: {
          lineColor: value,
        },
      },
      '#withLineColorMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withLineColorMixin(value): {
        ScatterSeriesConfig+: {
          lineColor+: value,
        },
      },
      lineColor+:
        {
          '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
          withField(value): {
            ScatterSeriesConfig+: {
              lineColor+: {
                field: value,
              },
            },
          },
          '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withFixed(value): {
            ScatterSeriesConfig+: {
              lineColor+: {
                fixed: value,
              },
            },
          },
        },
      '#withLineStyle': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withLineStyle(value): {
        ScatterSeriesConfig+: {
          lineStyle: value,
        },
      },
      '#withLineStyleMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withLineStyleMixin(value): {
        ScatterSeriesConfig+: {
          lineStyle+: value,
        },
      },
      lineStyle+:
        {
          '#withDash': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withDash(value): {
            ScatterSeriesConfig+: {
              lineStyle+: {
                dash:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withDashMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withDashMixin(value): {
            ScatterSeriesConfig+: {
              lineStyle+: {
                dash+:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withFill': { 'function': { args: [{ default: null, enums: ['solid', 'dash', 'dot', 'square'], name: 'value', type: ['string'] }], help: '' } },
          withFill(value): {
            ScatterSeriesConfig+: {
              lineStyle+: {
                fill: value,
              },
            },
          },
        },
      '#withLineWidth': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['integer'] }], help: '' } },
      withLineWidth(value): {
        ScatterSeriesConfig+: {
          lineWidth: value,
        },
      },
      '#withPointColor': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withPointColor(value): {
        ScatterSeriesConfig+: {
          pointColor: value,
        },
      },
      '#withPointColorMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withPointColorMixin(value): {
        ScatterSeriesConfig+: {
          pointColor+: value,
        },
      },
      pointColor+:
        {
          '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
          withField(value): {
            ScatterSeriesConfig+: {
              pointColor+: {
                field: value,
              },
            },
          },
          '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withFixed(value): {
            ScatterSeriesConfig+: {
              pointColor+: {
                fixed: value,
              },
            },
          },
        },
      '#withPointSize': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withPointSize(value): {
        ScatterSeriesConfig+: {
          pointSize: value,
        },
      },
      '#withPointSizeMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withPointSizeMixin(value): {
        ScatterSeriesConfig+: {
          pointSize+: value,
        },
      },
      pointSize+:
        {
          '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
          withField(value): {
            ScatterSeriesConfig+: {
              pointSize+: {
                field: value,
              },
            },
          },
          '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withFixed(value): {
            ScatterSeriesConfig+: {
              pointSize+: {
                fixed: value,
              },
            },
          },
          '#withMax': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withMax(value): {
            ScatterSeriesConfig+: {
              pointSize+: {
                max: value,
              },
            },
          },
          '#withMin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withMin(value): {
            ScatterSeriesConfig+: {
              pointSize+: {
                min: value,
              },
            },
          },
          '#withMode': { 'function': { args: [{ default: null, enums: ['linear', 'quad'], name: 'value', type: ['string'] }], help: '' } },
          withMode(value): {
            ScatterSeriesConfig+: {
              pointSize+: {
                mode: value,
              },
            },
          },
        },
      '#withShow': { 'function': { args: [{ default: null, enums: ['points', 'lines', 'points+lines'], name: 'value', type: ['string'] }], help: '' } },
      withShow(value): {
        ScatterSeriesConfig+: {
          show: value,
        },
      },
      '#withName': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withName(value): {
        ScatterSeriesConfig+: {
          name: value,
        },
      },
      '#withX': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withX(value): {
        ScatterSeriesConfig+: {
          x: value,
        },
      },
      '#withY': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withY(value): {
        ScatterSeriesConfig+: {
          y: value,
        },
      },
    },
  '#withScatterShow': { 'function': { args: [{ default: null, enums: ['points', 'lines', 'points+lines'], name: 'value', type: ['string'] }], help: '' } },
  withScatterShow(value): {
    ScatterShow: value,
  },
  '#withSeriesMapping': { 'function': { args: [{ default: null, enums: ['auto', 'manual'], name: 'value', type: ['string'] }], help: '' } },
  withSeriesMapping(value): {
    SeriesMapping: value,
  },
  '#withXYDimensionConfig': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
  withXYDimensionConfig(value): {
    XYDimensionConfig: value,
  },
  '#withXYDimensionConfigMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
  withXYDimensionConfigMixin(value): {
    XYDimensionConfig+: value,
  },
  XYDimensionConfig+:
    {
      '#withExclude': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withExclude(value): {
        XYDimensionConfig+: {
          exclude:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withExcludeMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withExcludeMixin(value): {
        XYDimensionConfig+: {
          exclude+:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withFrame': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['integer'] }], help: '' } },
      withFrame(value): {
        XYDimensionConfig+: {
          frame: value,
        },
      },
      '#withX': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
      withX(value): {
        XYDimensionConfig+: {
          x: value,
        },
      },
    },
  '#withOptions': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
  withOptions(value): {
    options: value,
  },
  '#withOptionsMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
  withOptionsMixin(value): {
    options+: value,
  },
  options+:
    {
      '#withLegend': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withLegend(value): {
        options+: {
          legend: value,
        },
      },
      '#withLegendMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withLegendMixin(value): {
        options+: {
          legend+: value,
        },
      },
      legend+:
        {
          '#withAsTable': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withAsTable(value=true): {
            options+: {
              legend+: {
                asTable: value,
              },
            },
          },
          '#withCalcs': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withCalcs(value): {
            options+: {
              legend+: {
                calcs:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withCalcsMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withCalcsMixin(value): {
            options+: {
              legend+: {
                calcs+:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withDisplayMode': { 'function': { args: [{ default: null, enums: ['list', 'table', 'hidden'], name: 'value', type: ['string'] }], help: 'TODO docs\nNote: "hidden" needs to remain as an option for plugins compatibility' } },
          withDisplayMode(value): {
            options+: {
              legend+: {
                displayMode: value,
              },
            },
          },
          '#withIsVisible': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withIsVisible(value=true): {
            options+: {
              legend+: {
                isVisible: value,
              },
            },
          },
          '#withPlacement': { 'function': { args: [{ default: null, enums: ['bottom', 'right'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
          withPlacement(value): {
            options+: {
              legend+: {
                placement: value,
              },
            },
          },
          '#withShowLegend': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withShowLegend(value=true): {
            options+: {
              legend+: {
                showLegend: value,
              },
            },
          },
          '#withSortBy': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withSortBy(value): {
            options+: {
              legend+: {
                sortBy: value,
              },
            },
          },
          '#withSortDesc': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withSortDesc(value=true): {
            options+: {
              legend+: {
                sortDesc: value,
              },
            },
          },
          '#withWidth': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withWidth(value): {
            options+: {
              legend+: {
                width: value,
              },
            },
          },
        },
      '#withTooltip': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withTooltip(value): {
        options+: {
          tooltip: value,
        },
      },
      '#withTooltipMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
      withTooltipMixin(value): {
        options+: {
          tooltip+: value,
        },
      },
      tooltip+:
        {
          '#withMode': { 'function': { args: [{ default: null, enums: ['single', 'multi', 'none'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
          withMode(value): {
            options+: {
              tooltip+: {
                mode: value,
              },
            },
          },
          '#withSort': { 'function': { args: [{ default: null, enums: ['asc', 'desc', 'none'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
          withSort(value): {
            options+: {
              tooltip+: {
                sort: value,
              },
            },
          },
        },
      '#withDims': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withDims(value): {
        options+: {
          dims: value,
        },
      },
      '#withDimsMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
      withDimsMixin(value): {
        options+: {
          dims+: value,
        },
      },
      dims+:
        {
          '#withExclude': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withExclude(value): {
            options+: {
              dims+: {
                exclude:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withExcludeMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
          withExcludeMixin(value): {
            options+: {
              dims+: {
                exclude+:
                  (if std.isArray(value)
                   then value
                   else [value]),
              },
            },
          },
          '#withFrame': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['integer'] }], help: '' } },
          withFrame(value): {
            options+: {
              dims+: {
                frame: value,
              },
            },
          },
          '#withX': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withX(value): {
            options+: {
              dims+: {
                x: value,
              },
            },
          },
        },
      '#withSeries': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withSeries(value): {
        options+: {
          series:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      '#withSeriesMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
      withSeriesMixin(value): {
        options+: {
          series+:
            (if std.isArray(value)
             then value
             else [value]),
        },
      },
      series+:
        {
          '#': { help: '', name: 'series' },
          '#withHideFrom': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
          withHideFrom(value): {
            hideFrom: value,
          },
          '#withHideFromMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
          withHideFromMixin(value): {
            hideFrom+: value,
          },
          hideFrom+:
            {
              '#withLegend': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withLegend(value=true): {
                hideFrom+: {
                  legend: value,
                },
              },
              '#withTooltip': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withTooltip(value=true): {
                hideFrom+: {
                  tooltip: value,
                },
              },
              '#withViz': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
              withViz(value=true): {
                hideFrom+: {
                  viz: value,
                },
              },
            },
          '#withAxisCenteredZero': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withAxisCenteredZero(value=true): {
            axisCenteredZero: value,
          },
          '#withAxisColorMode': { 'function': { args: [{ default: null, enums: ['text', 'series'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
          withAxisColorMode(value): {
            axisColorMode: value,
          },
          '#withAxisGridShow': { 'function': { args: [{ default: true, enums: null, name: 'value', type: ['boolean'] }], help: '' } },
          withAxisGridShow(value=true): {
            axisGridShow: value,
          },
          '#withAxisLabel': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withAxisLabel(value): {
            axisLabel: value,
          },
          '#withAxisPlacement': { 'function': { args: [{ default: null, enums: ['auto', 'top', 'right', 'bottom', 'left', 'hidden'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
          withAxisPlacement(value): {
            axisPlacement: value,
          },
          '#withAxisSoftMax': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withAxisSoftMax(value): {
            axisSoftMax: value,
          },
          '#withAxisSoftMin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withAxisSoftMin(value): {
            axisSoftMin: value,
          },
          '#withAxisWidth': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
          withAxisWidth(value): {
            axisWidth: value,
          },
          '#withScaleDistribution': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
          withScaleDistribution(value): {
            scaleDistribution: value,
          },
          '#withScaleDistributionMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
          withScaleDistributionMixin(value): {
            scaleDistribution+: value,
          },
          scaleDistribution+:
            {
              '#withLinearThreshold': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
              withLinearThreshold(value): {
                scaleDistribution+: {
                  linearThreshold: value,
                },
              },
              '#withLog': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
              withLog(value): {
                scaleDistribution+: {
                  log: value,
                },
              },
              '#withType': { 'function': { args: [{ default: null, enums: ['linear', 'log', 'ordinal', 'symlog'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
              withType(value): {
                scaleDistribution+: {
                  type: value,
                },
              },
            },
          '#withLabel': { 'function': { args: [{ default: null, enums: ['auto', 'never', 'always'], name: 'value', type: ['string'] }], help: 'TODO docs' } },
          withLabel(value): {
            label: value,
          },
          '#withLabelValue': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withLabelValue(value): {
            labelValue: value,
          },
          '#withLabelValueMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withLabelValueMixin(value): {
            labelValue+: value,
          },
          labelValue+:
            {
              '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
              withField(value): {
                labelValue+: {
                  field: value,
                },
              },
              '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
              withFixed(value): {
                labelValue+: {
                  fixed: value,
                },
              },
              '#withMode': { 'function': { args: [{ default: null, enums: ['fixed', 'field', 'template'], name: 'value', type: ['string'] }], help: '' } },
              withMode(value): {
                labelValue+: {
                  mode: value,
                },
              },
            },
          '#withLineColor': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withLineColor(value): {
            lineColor: value,
          },
          '#withLineColorMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withLineColorMixin(value): {
            lineColor+: value,
          },
          lineColor+:
            {
              '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
              withField(value): {
                lineColor+: {
                  field: value,
                },
              },
              '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
              withFixed(value): {
                lineColor+: {
                  fixed: value,
                },
              },
            },
          '#withLineStyle': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
          withLineStyle(value): {
            lineStyle: value,
          },
          '#withLineStyleMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: 'TODO docs' } },
          withLineStyleMixin(value): {
            lineStyle+: value,
          },
          lineStyle+:
            {
              '#withDash': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
              withDash(value): {
                lineStyle+: {
                  dash:
                    (if std.isArray(value)
                     then value
                     else [value]),
                },
              },
              '#withDashMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['array'] }], help: '' } },
              withDashMixin(value): {
                lineStyle+: {
                  dash+:
                    (if std.isArray(value)
                     then value
                     else [value]),
                },
              },
              '#withFill': { 'function': { args: [{ default: null, enums: ['solid', 'dash', 'dot', 'square'], name: 'value', type: ['string'] }], help: '' } },
              withFill(value): {
                lineStyle+: {
                  fill: value,
                },
              },
            },
          '#withLineWidth': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['integer'] }], help: '' } },
          withLineWidth(value): {
            lineWidth: value,
          },
          '#withPointColor': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withPointColor(value): {
            pointColor: value,
          },
          '#withPointColorMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withPointColorMixin(value): {
            pointColor+: value,
          },
          pointColor+:
            {
              '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
              withField(value): {
                pointColor+: {
                  field: value,
                },
              },
              '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
              withFixed(value): {
                pointColor+: {
                  fixed: value,
                },
              },
            },
          '#withPointSize': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withPointSize(value): {
            pointSize: value,
          },
          '#withPointSizeMixin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['object'] }], help: '' } },
          withPointSizeMixin(value): {
            pointSize+: value,
          },
          pointSize+:
            {
              '#withField': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: 'fixed: T -- will be added by each element' } },
              withField(value): {
                pointSize+: {
                  field: value,
                },
              },
              '#withFixed': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
              withFixed(value): {
                pointSize+: {
                  fixed: value,
                },
              },
              '#withMax': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
              withMax(value): {
                pointSize+: {
                  max: value,
                },
              },
              '#withMin': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['number'] }], help: '' } },
              withMin(value): {
                pointSize+: {
                  min: value,
                },
              },
              '#withMode': { 'function': { args: [{ default: null, enums: ['linear', 'quad'], name: 'value', type: ['string'] }], help: '' } },
              withMode(value): {
                pointSize+: {
                  mode: value,
                },
              },
            },
          '#withShow': { 'function': { args: [{ default: null, enums: ['points', 'lines', 'points+lines'], name: 'value', type: ['string'] }], help: '' } },
          withShow(value): {
            show: value,
          },
          '#withName': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withName(value): {
            name: value,
          },
          '#withX': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withX(value): {
            x: value,
          },
          '#withY': { 'function': { args: [{ default: null, enums: null, name: 'value', type: ['string'] }], help: '' } },
          withY(value): {
            y: value,
          },
        },
      '#withSeriesMapping': { 'function': { args: [{ default: null, enums: ['auto', 'manual'], name: 'value', type: ['string'] }], help: '' } },
      withSeriesMapping(value): {
        options+: {
          seriesMapping: value,
        },
      },
    },
  '#withType': { 'function': { args: [], help: '' } },
  withType(): {
    type: 'xychart',
  },
}
