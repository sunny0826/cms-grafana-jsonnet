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
    'RDS 监控',
    schemaVersion=20,
    tags=['RDS','阿里云'],
    refresh='5m',
    hideControls=true,
)
// Variables
.addTemplate(
    template.new(
        name='name',
        label='实例名称',
        datasource='Variable DataSource',
        query='rds',
        refresh='load',
    )
)
.addTemplate(
    template.new(
        name='id',
        datasource='Variable DataSource',
        query='rds($name)',
        refresh='load',
        hide=2,
    )
)
// 概览
.addPanel(
  row.new(
    title='概览',
    repeat='name'
  )
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 0,
    }
  )
// CPU 使用率
.addPanel(
  gauge.new(
    '',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    decimals=1,
    displayName='CPU 使用率',
    transparent=true,
    datasource="CMS Grafana Service",
  )
  .addThresholds(
      [
        { color: 'green', value: 0 },
        { color: '#EAB839', value: 80 },
        { color: 'red', value: 90 },
      ],
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'CpuUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 6,
    x: 0,
    y: 1,
  }
)
// 内存使用率
.addPanel(
  gauge.new(
    '',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    decimals=1,
    displayName='内存使用率',
    transparent=true,
    datasource="CMS Grafana Service",
  )
  .addThresholds(
      [
        { color: 'green', value: 0 },
        { color: '#EAB839', value: 80 },
        { color: 'red', value: 90 },
      ],
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'MemoryUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 6,
    x: 6,
    y: 1,
  }
)
// 磁盘使用率
.addPanel(
  gauge.new(
    '',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    decimals=1,
    displayName='磁盘使用率',
    transparent=true,
    datasource="CMS Grafana Service",
  )
  .addThresholds(
      [
        { color: 'green', value: 0 },
        { color: '#EAB839', value: 80 },
        { color: 'red', value: 90 },
      ],
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'DiskUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 6,
    x: 12,
    y: 1,
  }
)
// IOPS使用率
.addPanel(
  singlestat.new(
    '',
    colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
    datasource="CMS Grafana Service",
    colorBackground=true,
    decimals=2,
    prefixFontSize='80%',
    prefix='IOPS使用率',
    sparklineShow=true,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'IOPSUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 4,
    w: 6,
    x: 18,
    y: 1,
  }
)
// 连接数使用率
.addPanel(
  singlestat.new(
    '',
    colors=[
        "#5794F2",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
    datasource="CMS Grafana Service",
    colorBackground=true,
    decimals=2,
    prefixFontSize='80%',
    prefix='连接数使用率',
    sparklineShow=true,
    sparklineFillColor='#8AB8FF',
    sparklineLineColor='#F2495C',
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'ConnectionUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 4,
    w: 6,
    x: 18,
    y: 5,
  }
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
    w: 22,
    x: 0,
    y: 9,
  }
)
// 控制台链接
.addPanel(
  text.new(
      content='### [RDS 控制台](https://rds.console.aliyun.com/)',
      mode='markdown',
      transparent=true,
  ),gridPos={
    x: 22,
    y: 9,
    w: 2,
    h: 2,
  }
)
// 基础监控
.addPanel(
  row.new(
    title='基础监控',
    repeat='name'
  )
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 11,
    }
)
// CPU 使用率
.addPanel(
    graph.new(
        'CPU 使用率',
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
      dimensions: ["$id"],
      group: '',
      metric: 'CpuUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 12,
  }
)
// 内存使用率
.addPanel(
    graph.new(
        '内存使用率',
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
      dimensions: ["$id"],
      group: '',
      metric: 'MemoryUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 12,
  }
)
// 磁盘使用率
.addPanel(
    graph.new(
        '磁盘使用率',
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
      dimensions: ["$id"],
      group: '',
      metric: 'DiskUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 20,
  }
)
// 连接数使用率
.addPanel(
    graph.new(
        '连接数使用率',
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
      dimensions: ["$id"],
      group: '',
      metric: 'ConnectionUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 20,
  }
)
// IOPS使用率
.addPanel(
    graph.new(
        'IOPS使用率',
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
      dimensions: ["$id"],
      group: '',
      metric: 'IOPSUsage', 
      period: '60',
      project: 'acs_rds_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 28,
  }
)
// 网络监控
.addPanel(
  row.new(
    title='网络监控',
    repeat='name',
    collapse=true,
  )
// Mysql每秒网络入流量
.addPanel(
    graph.new(
        'Mysql每秒网络入流量',
        x_axis_mode='time',
        formatY1='bps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ["$id"],
      group: '',
      metric: 'MySQL_NetworkInNew', 
      period: '60',
      project: 'acs_rds_dashboard',
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
// Mysql每秒网络出流量
.addPanel(
    graph.new(
        'Mysql每秒网络出流量',
        x_axis_mode='time',
        formatY1='bps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ["$id"],
      group: '',
      metric: 'MySQL_NetworkOutNew', 
      period: '60',
      project: 'acs_rds_dashboard',
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
// Mysql当前活跃Sessions数
.addPanel(
    graph.new(
        'Mysql当前活跃Sessions数',
        x_axis_mode='time',
        formatY1='short',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ["$id"],
      group: '',
      metric: 'MySQL_ActiveSessions', 
      period: '60',
      project: 'acs_rds_dashboard',
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
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 36,
    }
)
