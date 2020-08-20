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
    'Dashboard',
    schemaVersion=20,
    tags=['阿里云'],
    refresh='5m',
    hideControls=true,
)
// Variables
.addTemplate(
    template.new(
        name='ecs',
        datasource='Variable DataSource',
        query='num(ecs)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.new(
        name='rds',
        datasource='Variable DataSource',
        query='num(rds)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.new(
        name='slb',
        datasource='Variable DataSource',
        query='num(slb)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.new(
        name='eip',
        datasource='Variable DataSource',
        query='num(eip)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.new(
        name='redis',
        datasource='Variable DataSource',
        query='num(redis)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.new(
        name='mongodb',
        datasource='Variable DataSource',
        query='num(mongodb)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.new(
        name='all_eip',
        datasource='Variable DataSource',
        query='all(eip)',
        refresh='load',
        hide=2,
    )
)
// 标题
.addPanel(
  text.new(
      content='\n<div class=\"text-center dashboard-header\">\n  <span>Dashboard</span>\n</div>\n\n\n\n',
      mode='html',
      transparent=true,
  ),gridPos={
    x: 0,
    y: 0,
    w: 24,
    h: 2,
  }
)
// ECS 数
.addPanel(
  text.new(
      content='\n<div class=\"text-center dashboard-header\">\n  <span>云服务器：$ecs 台</span>\n</div>\n\n',
      mode='html',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 4,
    x: 0,
    y: 2,
  }
)
// RDS 数
.addPanel(
  text.new(
      content='\n<div class=\"text-center dashboard-header\">\n  <span>云数据库RDS：$rds 台</span>\n</div>\n\n',
      mode='html',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 4,
    x: 4,
    y: 2,
  }
)
// MongoDB 数
.addPanel(
  text.new(
      content='\n<div class=\"text-center dashboard-header\">\n  <span>MongoDb：$mongodb 台</span>\n</div>\n\n',
      mode='html',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 4,
    x: 8,
    y: 2,
  }
)
// Redis 数
.addPanel(
  text.new(
      content='\n<div class=\"text-center dashboard-header\">\n  <span>Redis：$redis 台</span>\n</div>\n\n',
      mode='html',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 4,
    x: 12,
    y: 2,
  }
)
// SLB 数
.addPanel(
  text.new(
      content='\n<div class=\"text-center dashboard-header\">\n  <span>负载均衡：$slb 个</span>\n</div>\n\n',
      mode='html',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 4,
    x: 16,
    y: 2,
  }
)
// EIP 数
.addPanel(
  text.new(
      content='\n<div class=\"text-center dashboard-header\">\n  <span>弹性公网IP：$slb 个</span>\n</div>\n\n',
      mode='html',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 4,
    x: 20,
    y: 2,
  }
)
// CPU TOP1
.addPanel(
  gauge.new(
    'CPU TOP 1',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    displayName='${__series.name}',
    transparent=true,
    datasource="Variable DataSource",
  )
  .addThresholds(
      [
        { color: 'green', value: 0 },
        { color: '#EAB839', value: 80 },
        { color: 'red', value: 90 },
      ],
  )
  .addTargets(
      [
          {target: "cpu_top", type: "timeserie"},
      ],
  ), gridPos={
    h: 6,
    w: 4,
    x: 0,
    y: 4,
  }
)
// 内存 TOP1
.addPanel(
  gauge.new(
    '内存 TOP 1',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    displayName='${__series.name}',
    transparent=true,
    datasource="Variable DataSource"
  )
  .addThresholds(
      [
        { color: 'green', value: 0 },
        { color: '#EAB839', value: 80 },
        { color: 'red', value: 90 },
      ],
  )
  .addTargets(
      [
          {target: "mem_top", type: "timeserie"},
      ],
  ), gridPos={
    h: 6,
    w: 4,
    x: 4,
    y: 4,
  }
)
// 磁盘 TOP1
.addPanel(
  gauge.new(
    '磁盘 TOP 1',
    pluginVersion='6.4.2',
    unit="percent",
    max=100,
    min=0,
    displayName='${__series.name}',
    transparent=true,
    datasource="Variable DataSource",
  )
  .addThresholds(
      [
        { color: 'green', value: 0 },
        { color: '#EAB839', value: 80 },
        { color: 'red', value: 90 },
      ],
  )
  .addTargets(
      [
          {target: "disk_top", type: "timeserie"},
      ],
  ), gridPos={
    h: 6,
    w: 4,
    x: 8,
    y: 4,
  }
)
// CPU TOP10
.addPanel(
    bargauge.new(
        'CPU TOP10',
        datasource='Variable DataSource',
        unit='percent', 
        thresholds=[
          { color: 'green', value: 0 },
          { color: '#EAB839', value: 80 },
          { color: 'red', value: 90 },
        ],
    ) {
        options: {
        displayMode: "gradient",
        orientation: "horizontal",
        reduceOptions: {
            calcs: [
            "mean"
            ],
            fields: "",
            values: false
        },
        showUnfilled: true
        },
    }
    .addTargets(
      [
          {target: "cpu_top_10", type: "timeserie"},
      ],
    ), gridPos={
    h: 22,
    w: 4,
    x: 16,
    y: 4,
   } 
)
// 内存 TOP10
.addPanel(
    bargauge.new(
        '内存 TOP10',
        datasource='Variable DataSource',
        unit='percent', 
        thresholds=[
          { color: 'green', value: 0 },
          { color: '#EAB839', value: 80 },
          { color: 'red', value: 90 },
        ],
    ) {
        options: {
        displayMode: "gradient",
        orientation: "horizontal",
        reduceOptions: {
            calcs: [
            "mean"
            ],
            fields: "",
            values: false
        },
        showUnfilled: true
        },
    }
    .addTargets(
      [
          {target: "mem_top_10", type: "timeserie"},
      ],
    ), gridPos={
    h: 22,
    w: 4,
    x: 20,
    y: 4,
   } 
)
// OSS存储量
.addPanel(
  singlestat.new(
    'OSS存储量',
     colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
     ],
     format='decbytes',
     valueName='current',
     datasource="CMS Grafana Service",
     colorBackground=true,
     decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: [],
      metric: 'MeteringStorageUtilization', 
      period: '3600',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 3,
    w: 4,
    x: 12,
    y: 4,
  }
)
// 总请求数
.addPanel(
  singlestat.new(
    '总请求数',
     colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#1F60C4",
     ],
     format='short',
     valueName='current',
     datasource="CMS Grafana Service",
     colorBackground=true,
     decimals=2,
  )
  .addTarget(
    {
      describe: '',
      dimensions: [],
      group: '',
      metric: 'UserTotalRequestCount', 
      period: '3600',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 3,
    w: 4,
    x: 12,
    y: 4,
  }
)
// OSS公网流入流量
.addPanel(
  singlestat.new(
    'OSS公网流入流量',
     colors=[
        "#3274D9",
        "rgba(237, 129, 40, 0.89)",
        "#299c46",
     ],
     format='decbytes',
     valueName='current',
     datasource="CMS Grafana Service",
     colorBackground=true,
     decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: [],
      metric: 'UserInternetRecv', 
      period: '3600',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 3,
    w: 4,
    x: 12,
    y: 10,
  }
)
// OSS公网流出流量
.addPanel(
  singlestat.new(
    'OSS公网流出流量',
     colors=[
        "#1F60C4",
        "rgba(237, 129, 40, 0.89)",
        "#299c46",
     ],
     format='decbytes',
     valueName='current',
     datasource="CMS Grafana Service",
     colorBackground=true,
     decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: [],
      metric: 'UserInternetSend', 
      period: '3600',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 3,
    w: 4,
    x: 12,
    y: 13,
  }
)
// 磁盘 TOP10
.addPanel(
    bargauge.new(
        '磁盘 TOP10',
        datasource='Variable DataSource',
        unit='percent', 
        thresholds=[
          { color: 'green', value: 0 },
          { color: '#EAB839', value: 80 },
          { color: 'red', value: 90 },
        ],
    ) {
        options: {
        displayMode: "lcd",
        orientation: "vertical",
        reduceOptions: {
            calcs: [
            "mean"
            ],
            fields: "",
            values: false
        },
        showUnfilled: true
        },
    }
    .addTargets(
      [
          {target: "disk_top_10", type: "timeserie"},
      ],
    ), gridPos={
    h: 6,
    w: 12,
    x: 0,
    y: 10,
   } 
)
// 流出带宽
.addPanel(
    graph.new(
        '流出带宽',
        x_axis_mode='time',
        formatY1='bps',
        fill=2,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=2,
        pointradius=2,
    )
    .addTarget(
    {
    dimensions: [
            "$all_eip",","
    ],
    group: '',
    metric: 'net_tx.rate', 
    period: '60',
    project: 'acs_vpc_eip',
    target: ['Value'],
    type: 'timeserie',
    xcol: 'timestamp',
    ycol: ['Value']
    },
    ), gridPos={
    h: 10,
    w: 8,
    x: 0,
    y: 16,
  }
)
// 流入带宽
.addPanel(
    graph.new(
        '流入带宽',
        x_axis_mode='time',
        formatY1='bps',
        fill=2,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=2,
        pointradius=2,
    )
    .addTarget(
    {
    dimensions: [
            "$all_eip",","
    ],
    group: '',
    metric: 'net_rx.rate', 
    period: '60',
    project: 'acs_vpc_eip',
    target: ['Value'],
    type: 'timeserie',
    xcol: 'timestamp',
    ycol: ['Value']
    },
    ), gridPos={
    h: 10,
    w: 8,
    x: 8,
    y: 16,
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
    h: 3,
    w: 24,
    x: 0,
    y: 26,
  }
)