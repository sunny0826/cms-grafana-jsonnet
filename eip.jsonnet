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
    '弹性公网IP',
    schemaVersion=20,
    tags=['EIP','阿里云'],
    refresh='5m',
    hideControls=true,
)
// Variables
.addTemplate(
    template.new(
        name='name',
        label='实例名称',
        datasource='Variable DataSource',
        query='eip',
        refresh='load',
        includeAll=true,
        multi=true,
    )
)
.addTemplate(
    template.new(
        name='id',
        datasource='Variable DataSource',
        query='eip($name)',
        refresh='load',
        hide=2,
    )
)
// 流出带宽
.addPanel(
    graph.new(
        '流出带宽',
        x_axis_mode='time',
        formatY1='bps',
        formatY2='short',
        fill=2,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ["$id,"],
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
    h: 8,
    w: 12,
    x: 0,
    y: 0,
  }
)
// 流入带宽
.addPanel(
    graph.new(
        '流入带宽',
        x_axis_mode='time',
        formatY1='bps',
        formatY2='short',
        fill=2,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ["$id,"],
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
    h: 8,
    w: 12,
    x: 12,
    y: 0,
  }
)
// 每秒流出数据包数
.addPanel(
    graph.new(
        '每秒流出数据包数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=2,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ["$id,"],
      group: '',
      metric: 'net_txPkgs.rate', 
      period: '60',
      project: 'acs_vpc_eip',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 0,
    y: 8,
  }
)
// 每秒流入数据包数
.addPanel(
    graph.new(
        '每秒流入数据包数',
        x_axis_mode='time',
        formatY1='cps',
        formatY2='short',
        fill=2,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
      {
      dimensions: ["$id,"],
      group: '',
      metric: 'net_rxPkgs.rate', 
      period: '60',
      project: 'acs_vpc_eip',
      target: ['Value'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Value']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 8,
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
    y: 16,
  }
)
// 控制台链接
.addPanel(
  text.new(
      content='### [EIP 控制台](https://vpc.console.aliyun.com/eip/)',
      mode='markdown',
      transparent=true,
  ),gridPos={
    x: 22,
    y: 16,
    w: 2,
    h: 2,
  }
)