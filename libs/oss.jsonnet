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
    'OSS监控',
    schemaVersion=20,
    tags=['OSS','阿里云'],
    refresh='5m',
    hideControls=true,
)
// Variables
.addTemplate(
    template.new(
        name='dimension',
        label='Bucket名称',
        datasource='CMS Grafana Service',
        query='dimension(acs_oss_dashboard, Availability,null,null),',
        refresh='load',
    )
)
.addTemplate(
    template.custom(
      'method',
      "GetObjectE2eLatency, GetObjectServerLatency, MaxGetObjectE2eLatency, MaxGetObjectServerLatency, HeadObjectE2eLatency, HeadObjectServerLatency, MaxHeadObjectE2eLatency,MaxHeadObjectServerLatency,PutObjectE2eLatency,PutObjectServerLatency,MaxPutObjectE2eLatency,MaxPutObjectServerLatency,PostObjectE2eLatency,PostObjectServerLatency,MaxPostObjectE2eLatency,MaxPostObjectServerLatency,AppendObjectE2eLatency,AppendObjectServerLatency,MaxAppendObjectE2eLatency,MaxAppendObjectServerLatency,UploadPartE2eLatency,UploadPartServerLatency,MaxUploadPartE2eLatency,MaxUploadPartServerLatency,UploadPartCopyE2eLatency,UploadPartCopyServerLatency,MaxUploadPartCopyE2eLatency,MaxUploadPartCopyServerLatency",
      'GetObjectE2eLatency',
      label='请求',
      refresh='load',
    )
)
.addTemplate(
    template.custom(
      'success',
      "GetObjectCount,HeadObjectCount,PutObjectCount,PostObjectCount,AppendObjectCount,UploadPartCount,UploadPartCopyCount,DeleteObjectCount,DeleteObjectsCount",
      'GetObjectCount',
      label='成功请求方法',
      refresh='load',
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
      content='### [OSS 控制台](https://oss.console.aliyun.com/)',
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
    title='用户层级',
    repeat='name'
  )
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 2,
    }
)
// 用户层级有效请求率
.addPanel(
    graph.new(
        '用户层级有效请求率',
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
      dimensions: [],
      group: '',
      metric: 'UserRequestValidRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
      },
    ), gridPos={
    h: 6,
    w: 24,
    x: 0,
    y: 3,
  }
)
// 用户层级总请求数
.addPanel(
  singlestat.new(
    '用户层级总请求数',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: [],
      metric: 'UserTotalRequestCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 0,
    y: 9,
  }
)
// 用户层级有效请求数
.addPanel(
  singlestat.new(
    '用户层级有效请求数',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: [],
      metric: 'UserValidRequestCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 4,
    y: 9,
  }
)
// 用户层级公网流出流量
.addPanel(
  singlestat.new(
    '用户层级公网流出流量',
    colors=[
        "#5794F2",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bytes',
    valueName='current',
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
      dimensions: [],
      metric: 'UserInternetSend', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 8,
    y: 9,
  }
)
// 用户层级公网流入流量
.addPanel(
  singlestat.new(
    '用户层级公网流入流量',
    colors=[
        "#5794F2",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bytes',
    valueName='current',
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
      dimensions: [],
      metric: 'UserInternetRecv', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 12,
    y: 9,
  }
)
// 用户层级内网流出流量
.addPanel(
  singlestat.new(
    '用户层级内网流出流量',
    colors=[
        "#3274D9",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bytes',
    valueName='current',
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
      dimensions: [],
      metric: 'UserIntranetSend', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 16,
    y: 9,
  }
)
// 用户层级内网流入流量
.addPanel(
  singlestat.new(
    '用户层级内网流入流量',
    colors=[
        "#3274D9",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bytes',
    valueName='current',
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
      dimensions: [],
      metric: 'UserIntranetRecv', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 20,
    y: 9,
  }
)
// 用户层级成功请求占比
.addPanel(
  singlestat.new(
    '用户层级成功请求占比',
    colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
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
      dimensions: [],
      metric: 'UserSuccessRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 0,
    y: 14,
  }
)
// 用户层级成功请求总数
.addPanel(
  singlestat.new(
    '用户层级成功请求总数',
    colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: [],
      metric: 'UserSuccessCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 4,
    y: 14,
  }
)
// 用户层级服务端错误请求总数
.addPanel(
  singlestat.new(
    '用户层级服务端错误请求总数',
    colors=[
        "#E02F44",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: [],
      metric: 'UserServerErrorCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 8,
    y: 14,
  }
)
// 用户层级服务端错误请求占比
.addPanel(
  singlestat.new(
    '用户层级服务端错误请求占比',
    colors=[
        "#E02F44",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
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
      dimensions: [],
      metric: 'UserServerErrorRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 12,
    y: 14,
  }
)
// 用户层级网络错误请求总数
.addPanel(
  singlestat.new(
    '用户层级网络错误请求总数',
    colors=[
        "#C4162A",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: [],
      metric: 'UserNetworkErrorCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 16,
    y: 14,
  }
)
// 用户层级网络错误请求占
.addPanel(
  singlestat.new(
    '用户层级网络错误请求占',
    colors=[
        "#C4162A",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
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
      dimensions: [],
      metric: 'UserNetworkErrorRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 20,
    y: 14,
  }
)
// row Bucket层级
.addPanel(
  row.new(
    title='Bucket层级',
    repeat='name',
    collapse=true,
  )
// 可用性
.addPanel(
  singlestat.new(
    '可用性',
    colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'Availability', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 0,
    y: 20,
  }
)
// 有效请求率
.addPanel(
  singlestat.new(
    '有效请求率',
    colors=[
        "#d44a3a",
        "rgba(237, 129, 40, 0.89)",
        "#56A64B",
    ],
    format='percent',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'RequestValidRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 4,
    y: 20,
  }
)
// 内网流出流量
.addPanel(
  singlestat.new(
    '内网流出流量',
    colors=[
        "#1F60C4",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bytes',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'IntranetSend', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 8,
    y: 20,
  }
)
// 内网流入流量
.addPanel(
  singlestat.new(
    '内网流入流量',
    colors=[
        "#1F60C4",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bytes',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'IntranetRecv', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 12,
    y: 20,
  }
)
// 公网流出流量
.addPanel(
  singlestat.new(
    '公网流出流量',
    colors=[
        "#5794F2",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bytes',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'InternetSend', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 16,
    y: 20,
  }
)
// 公网流入流量
.addPanel(
  singlestat.new(
    '公网流入流量',
    colors=[
        "#5794F2",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bytes',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'InternetRecv', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 20,
    y: 20,
  }
)
// 总请求数
.addPanel(
  singlestat.new(
    '总请求数',
    colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'TotalRequestCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 0,
    y: 25,
  }
)
// 有效请求数
.addPanel(
  singlestat.new(
    '有效请求数',
    colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'ValidRequestCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 4,
    y: 25,
  }
)
// 服务端错误请求总数
.addPanel(
  singlestat.new(
    '服务端错误请求总数',
    colors=[
        "#d44a3a",
        "rgba(237, 129, 40, 0.89)",
        "#56A64B",
    ],
    format='none',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'ServerErrorCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 8,
    y: 25,
  }
)
// 服务端错误请求占比
.addPanel(
  singlestat.new(
    '服务端错误请求占比',
    colors=[
        "#d44a3a",
        "rgba(237, 129, 40, 0.89)",
        "#56A64B",
    ],
    format='percent',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'ServerErrorRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 12,
    y: 25,
  }
)
// 网络错误请求总数
.addPanel(
  singlestat.new(
    '网络错误请求总数',
    colors=[
        "#F2495C",
        "rgba(237, 129, 40, 0.89)",
        "#56A64B",
    ],
    format='none',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'NetworkErrorCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 16,
    y: 25,
  }
)
// 网络错误请求占比
.addPanel(
  singlestat.new(
    '网络错误请求占比',
    colors=[
        "#F2495C",
        "rgba(237, 129, 40, 0.89)",
        "#56A64B",
    ],
    format='percent',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'NetworkErrorRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 20,
    y: 25,
  }
)
// 客户端资源不存在错误请求总数
.addPanel(
  singlestat.new(
    '客户端资源不存在错误请求总数',
    colors=[
        "#E0B400",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'ResourceNotFoundErrorCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 0,
    y: 30,
  }
)
// 客户端资源不存在错误请求占比
.addPanel(
  singlestat.new(
    '客户端资源不存在错误请求占比',
    colors=[
        "#E0B400",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'ResourceNotFoundErrorRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 4,
    y: 30,
  }
)
// 客户端超时错误请求总数
.addPanel(
  singlestat.new(
    '客户端超时错误请求总数',
    colors=[
        "#FF9830",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'ClientTimeoutErrorCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 8,
    y: 30,
  }
)
// 客户端超时错误请求占比
.addPanel(
  singlestat.new(
    '客户端超时错误请求占比',
    colors=[
        "#FF9830",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'ClientTimeoutErrorRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 12,
    y: 30,
  }
)
// 成功请求总数
.addPanel(
  singlestat.new(
    '成功请求总数',
    colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='none',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'SuccessCount', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 16,
    y: 30,
  }
)
// 成功请求占比
.addPanel(
  singlestat.new(
    '成功请求占比',
    colors=[
        "#56A64B",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='percent',
    valueName='current',
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
      dimensions: ["$dimension"],
      metric: 'SuccessRate', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 20,
    y: 30,
  }
)
// $method 请求平均延时
.addPanel(
    graph.new(
        '$method 请求平均延时',
        description='参数详情查看 https://help.aliyun.com/document_detail/31879.html',
        x_axis_mode='time',
        formatY1='ms',
        formatY2='ms',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: [],
      group: '',
      metric: '$method', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 35,
  }
)
// $success 成功请求数
.addPanel(
    graph.new(
        '$success 成功请求数',
        description='参数详情查看 https://help.aliyun.com/document_detail/31879.html',
        x_axis_mode='time',
        formatY1='none',
        formatY2='ms',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: [],
      group: '',
      metric: '$success', 
      period: '60',
      project: 'acs_oss_dashboard',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 35,
  }
)
,gridPos={
    h: 1,
    w: 24,
    x: 0,
    y: 19,
  }
)
