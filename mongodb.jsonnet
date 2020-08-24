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
    'MongoDB监控',
    schemaVersion=20,
    tags=['MongoDB','阿里云'],
    refresh='5m',
    hideControls=true,
)
// Variables
.addTemplate(
    template.new(
        name='name',
        label='实例名称',
        datasource='Variable DataSource',
        query='mongodb',
        refresh='load',
    )
)
.addTemplate(
    template.new(
        name='id',
        datasource='Variable DataSource',
        query='mongodb($name)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.custom(
      'method',
      'OpInsert, OpQuery, OpUpdate, OpDelete, OpGetmore, OpCommand',
      'OpCommand',
      label='操作',
      refresh='load',
    )
)
.addTemplate(
    template.new(
        name='num',
        label='实例数',
        datasource='Variable DataSource',
        query='num(mongodb)',
        refresh='load',
    )
)
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
    'CPU 使用率',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    decimals=1,
    displayName='',
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
      metric: 'CPUUtilization', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 0,
    y: 1,
  }
)
// 内存使用率
.addPanel(
  gauge.new(
    '内存使用率',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    decimals=1,
    displayName='',
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
      metric: 'MemoryUtilization', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 4,
    y: 1,
  }
)
// 磁盘使用率
.addPanel(
  gauge.new(
    '磁盘使用率',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    decimals=1,
    displayName='',
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
      metric: 'DiskUtilization', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 4,
    x: 8,
    y: 1,
  }
)
// IOPS使用率
.addPanel(
  singlestat.new(
    'IOPS使用率',
    format='percent',
    valueName='avg',
    datasource="CMS Grafana Service",
    colorBackground=false,
    decimals=2,
    prefixFontSize='70%',
    prefix='',
    sparklineShow=true,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'IOPSUtilization', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 3,
    x: 12,
    y: 1,
  }
)
// 请求数
.addPanel(
  singlestat.new(
    '请求数',
    format='none',
    valueName='current',
    datasource="CMS Grafana Service",
    colorBackground=false,
    decimals=2,
    postfixFontSize='50%',
    prefixFontSize='80%',
    prefix='',
    sparklineShow=true,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'NumberRequests', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 3,
    x: 15,
    y: 1,
  }
)
// 平均每秒SQL查询数
.addPanel(
  singlestat.new(
    '平均每秒SQL查询数',
    format='none',
    valueName='current',
    datasource="CMS Grafana Service",
    colorBackground=false,
    decimals=2,
    postfixFontSize='50%',
    prefixFontSize='70%',
    prefix='',
    sparklineShow=true,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'QPS', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 3,
    x: 18,
    y: 1,
  }
)
// 连接数使用量
.addPanel(
  singlestat.new(
    '连接数使用量',
    format='none',
    valueName='current',
    datasource="CMS Grafana Service",
    colorBackground=false,
    decimals=2,
    postfixFontSize='50%',
    prefixFontSize='70%',
    prefix='',
    sparklineShow=true,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'ConnectionAmount', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 6,
    w: 3,
    x: 21,
    y: 1,
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
    w: 21,
    x: 0,
    y: 7,
  }
)
// 控制台链接
.addPanel(
  text.new(
      content='## [MongoDB 控制台](https://mongodb.console.aliyun.com/)',
      mode='markdown',
      transparent=true,
  ),gridPos={
    x: 21,
    y: 7,
    w: 3,
    h: 2,
  }
)
// 趋势
.addPanel(
  row.new(
    title='趋势',
    repeat='name'
  )
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 9,
    }
)
// 平均每秒SQL查询数
.addPanel(
    graph.new(
        '平均每秒SQL查询数',
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
      metric: 'QPS', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 10,
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
      metric: 'IOPSUtilization', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 10,
  }
)
// $method 操作次数
.addPanel(
    graph.new(
        '$method 操作次数',
        x_axis_mode='time',
        formatY1='none',
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
      metric: '$method', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 18,
  }
)
// 请求数
.addPanel(
    graph.new(
        '请求数',
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
      metric: 'NumberRequests', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 18,
  }
)
// 资源
.addPanel(
  row.new(
    title='资源',
    repeat='name'
  )
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 26,
    }
)
// CPU使用率
.addPanel(
    graph.new(
        'CPU使用率',
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
      metric: 'CPUUtilization', 
      period: '300',
      project: 'acs_mongodb',
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
      metric: 'MemoryUtilization', 
      period: '300',
      project: 'acs_mongodb',
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
// 网络入流量
.addPanel(
    graph.new(
        '网络入流量',
        x_axis_mode='time',
        formatY1='bytes',
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
      metric: 'IntranetIn', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 36,
  }
)
// 网络出流量
.addPanel(
    graph.new(
        '网络出流量',
        x_axis_mode='time',
        formatY1='bytes',
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
      metric: 'IntranetOut', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 36,
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
      metric: 'DiskUtilization', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 42,
  }
)
// 数据占用磁盘空间量
.addPanel(
    graph.new(
        '数据占用磁盘空间量',
        x_axis_mode='time',
        formatY1='bytes',
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
      metric: 'DataDiskAmount', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 42,
  }
)
// 实例占用磁盘空间量
.addPanel(
    graph.new(
        '实例占用磁盘空间量',
        x_axis_mode='time',
        formatY1='bytes',
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
      metric: 'InstanceDiskAmount', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 50,
  }
)
// 日志占用磁盘空间量
.addPanel(
    graph.new(
        '日志占用磁盘空间量',
        x_axis_mode='time',
        formatY1='bytes',
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
      metric: 'LogDiskAmount', 
      period: '300',
      project: 'acs_mongodb',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 50,
  }
)
