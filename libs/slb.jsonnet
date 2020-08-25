local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local singlestat = grafana.singlestat;
local prometheus = grafana.prometheus;
local template = grafana.template;
local text = grafana.text;
local gauge = grafana.gaugePanel;
local bargauge = grafana.barGaugePanel;
local graph = grafana.graphPanel;
local theme = grafana.theme;

dashboard.new(
    'SLB监控',
    schemaVersion=20,
    tags=['SLB','阿里云'],
    refresh='5m',
    hideControls=true,
)
// Variables
.addTemplate(
    template.new(
        name='name',
        label='实例名称',
        datasource='Variable DataSource',
        query='slb',
        refresh='load',
    )
)
.addTemplate(
    template.new(
        name='id',
        datasource='Variable DataSource',
        query='slb($name)',
        refresh='load',
        hide=2,
    )
)
// 主题
.addPanel(
    theme.new()
    .addTheme(
        "Start Theme",
        bgimage="https://images.unsplash.com/photo-1524334228333-0f6db392f8a1",
        style=".panel-container {\n    background-color: rgba(0,0,0,0.3);\n}",
    )
    .addTheme(
        "Aquamarine Theme",
        url="https://gilbn.github.io/theme.park/CSS/themes/grafana/aquamarine.css"
    )
    .addTheme(
        "Hotline Theme",
        url="https://gilbn.github.io/theme.park/CSS/themes/grafana/hotline.css"
    )
    .addTheme(
        "Dark Theme",
        url="https://gilbn.github.io/theme.park/CSS/themes/grafana/dark.css"
    )
    .addTheme(
        "Plex Theme",
        url="https://gilbn.github.io/theme.park/CSS/themes/grafana/plex.css"
    )
    .addTheme(
        "Space Gray Theme",
        url="https://gilbn.github.io/theme.park/CSS/themes/grafana/space-gray.css"
    )
    .addTheme(
        "Organizr Theme",
        url="https://gilbn.github.io/theme.park/CSS/themes/grafana/organizr-dashboard.css"
    ), gridPos={
    h: 2,
    w: 20,
    x: 0,
    y: 0,
  }
)
// 控制台链接
.addPanel(
  text.new(
      content='### [SLB 控制台](https://slb.console.aliyun.com/slb/overview)',
      mode='markdown',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 2,
    x: 22,
    y: 0,
  }
)
// row 用户层级
.addPanel(
  row.new(
    title='',
    repeat='dimension'
  )
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 2,
    }
)
// 4层
.addPanel(
  text.new(
      content="<div class=\"text-center dashboard-header\">\n  <span>4层</span>\n</div>",
      mode='html',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 24,
    x: 0,
    y: 3,
  }
)
// 后端健康ECS实例个数
.addPanel(
  singlestat.new(
    '后端健康ECS实例个数',
    colors=[
        "#73BF69",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'HeathyServerCount', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 0,
    y: 5,
  }
)
// 后端异常ECS实例个数
.addPanel(
  singlestat.new(
    '后端异常ECS实例个数',
    colors=[
        "#F2495C",
        "rgba(237, 129, 40, 0.89)",
        "#F2495C",
    ],
    format='none',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'UnhealthyServerCount', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 4,
    y: 5,
  }
)
// 实例每秒活跃连接数
.addPanel(
  singlestat.new(
    '实例每秒活跃连接数',
    colors=[
        "#73BF69",
        "rgba(237, 129, 40, 0.89)",
        "#F2495C",
    ],
    format='none',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceActiveConnection', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 8,
    y: 5,
  }
)
// 实例每秒丢失连接数
.addPanel(
  singlestat.new(
    '实例每秒丢失连接数',
    colors=[
        "#F2495C",
        "rgba(237, 129, 40, 0.89)",
        "#F2495C",
    ],
    format='none',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceDropConnection', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 12,
    y: 5,
  }
)
// 实例每秒入bit数
.addPanel(
  singlestat.new(
    '实例每秒入bit数',
    colors=[
        "#1F60C4",
        "rgba(237, 129, 40, 0.89)",
        "#F2495C",
    ],
    format='bps',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceTrafficRX', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 16,
    y: 5,
  }
)
// 实例每秒出bit数
.addPanel(
  singlestat.new(
    '实例每秒出bit数',
    colors=[
        "#1F60C4",
        "rgba(237, 129, 40, 0.89)",
        "#F2495C",
    ],
    format='bps',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceTrafficTX', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 20,
    y: 5,
  }
)
// 新建连接数使用率
.addPanel(
    graph.new(
        '新建连接数使用率',
        x_axis_mode='time',
        formatY1='percent',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceNewConnectionUtilization', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 11,
  }
)
// 最大连接数使用率
.addPanel(
    graph.new(
        '最大连接数使用率',
        x_axis_mode='time',
        formatY1='percent',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceMaxConnectionUtilization', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 11,
  }
)
// 实例每秒活跃连接数
.addPanel(
    graph.new(
        '实例每秒活跃连接数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceActiveConnection', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 19,
  }
)
// 实例每秒丢失连接数
.addPanel(
    graph.new(
        '实例每秒丢失连接数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceDropConnection', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 19,
  }
)
// 实例每秒丢失入包数
.addPanel(
    graph.new(
        '实例每秒丢失入包数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceDropPacketRX', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 27,
  }
)
// 实例每秒丢失出包数
.addPanel(
    graph.new(
        '实例每秒丢失出包数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceDropPacketTX', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 27,
  }
)
// 实例每秒非活跃连接数
.addPanel(
    graph.new(
        '实例每秒非活跃连接数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceInactiveConnection', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 35,
  }
)
// 实例每秒最大并发连接数
.addPanel(
    graph.new(
        '实例每秒最大并发连接数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceMaxConnection', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 35,
  }
)
// 实例每秒入包数
.addPanel(
    graph.new(
        '实例每秒入包数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstancePacketRX', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 43,
  }
)
// 实例每秒出包数
.addPanel(
    graph.new(
        '实例每秒出包数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstancePacketTX', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 43,
  }
)
// 实例每秒新建连接数
.addPanel(
    graph.new(
        '实例每秒新建连接数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ['$id'],
      group: '',
      metric: 'InstanceNewConnection', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 24,
    x: 0,
    y: 51,
  }
)
// row 7级
.addPanel(
  row.new(
    title='',
    repeat='dimension',
    collapse=true,
  )
// 7层
.addPanel(
  text.new(
      content= "<div class=\"text-center dashboard-header\">\n  <span>7层</span>\n</div>",
      mode='html',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 24,
    x: 0,
    y: 4,
  }
)
// 实例维度2xx状态码
.addPanel(
  singlestat.new(
    '实例维度2xx状态码',
    colors=[
        "#73BF69",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='cps',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceStatusCode2xx', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 0,
    y: 6,
  }
)
// 实例维度3xx状态码
.addPanel(
  singlestat.new(
    '实例维度3xx状态码',
    colors=[
        "#73BF69",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='cps',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceStatusCode3xx', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 4,
    y: 6,
  }
)
// 实例维度的请求平均延时
.addPanel(
  singlestat.new(
    '实例维度的请求平均延时',
    colors=[
        "#73BF69",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='cps',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceRt', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 8,
    y: 6,
  }
)
// 实例维度4xx状态码
.addPanel(
  singlestat.new(
    '实例维度4xx状态码',
    colors=[
        "#FF780A",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='cps',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceStatusCode4xx', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 12,
    y: 6,
  }
)
// 实例维度5xx状态码
.addPanel(
  singlestat.new(
    '实例维度5xx状态码',
    colors=[
        "#E02F44",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='cps',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceStatusCode5xx', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 16,
    y: 6,
  }
)
// QPS使用率
.addPanel(
  singlestat.new(
    'QPS使用率',
    colors=[
        "#73BF69",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='avg',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='50%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceQpsUtilization', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 3,
    w: 4,
    x: 20,
    y: 6,
  }
)
// 实例维度的QPS
.addPanel(
  singlestat.new(
    '实例维度的QPS',
    colors=[
        "#73BF69",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='cps',
    valueName='current',
    colorBackground=true,
    datasource="CMS Grafana Service",
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ['$id'],
      metric: 'InstanceQps', 
      period: '60',
      project: 'acs_slb_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 3,
    w: 4,
    x: 20,
    y: 9,
  }
)
,gridPos={
    h: 1,
    w: 24,
    x: 0,
    y: 59,
  }
)