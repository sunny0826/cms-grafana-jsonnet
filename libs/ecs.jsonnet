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
    'ECS 监控',
    schemaVersion=20,
    tags=['ECS','阿里云'],
    refresh='5m',
    hideControls=true,
)
// Variables
.addTemplate(
    template.new(
        name='name',
        label='实例名称',
        datasource='Variable DataSource',
        query='ecs',
        refresh='load',
    )
)
.addTemplate(
    template.new(
        name='id',
        datasource='Variable DataSource',
        query='ecs($name)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.new(
        name='dimension',
        label='实例ID',
        datasource='CMS Grafana Service',
        query='dimension(acs_ecs_dashboard, CPUUtilization,$id,null),',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.new(
        name='ip',
        label='IP',
        datasource='Variable DataSource',
        query='ecs_ip($name)',
        refresh='load',
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
// IP
.addPanel(
  text.new(
      content='<div class=\"text-center dashboard-header\">\n  <span>$ip</span>\n</div>\n\n\n\n',
      mode='html',
      transparent=true,
  ),gridPos={
    x: 0,
    y: 1,
    w: 4,
    h: 2,
  }
)
// 内存总量
.addPanel(
  singlestat.new(
    '内存总量',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='decbytes',
    valueName='avg',
    datasource="CMS Grafana Service",
    colorBackground=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'memory_totalspace', 
      period: '15',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 2,
    w: 4,
    x: 4,
    y: 1,
  }
)
// 磁盘总量
.addPanel(
  singlestat.new(
    '磁盘总量',
    colors=[
        "#1F60C4",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='decbytes',
    valueName='avg',
    datasource="CMS Grafana Service",
    colorBackground=true,
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'diskusage_total', 
      period: '15',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 2,
    w: 4,
    x: 8,
    y: 1,
  }
)
// 私网流入带宽
.addPanel(
  singlestat.new(
    '私网流入带宽',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bps',
    valueName='current',
    datasource="CMS Grafana Service",
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'IntranetInRate', 
      period: '60',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 12,
    y: 1,
  }
)
// 系统磁盘总读BPS
.addPanel(
  singlestat.new(
    '系统磁盘总读BPS',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='Bps',
    valueName='current',
    datasource="CMS Grafana Service",
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'DiskReadBPS', 
      period: '60',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 16,
    y: 1,
  }
)
// 系统磁盘读IOPS
.addPanel(
  singlestat.new(
    '系统磁盘读IOPS',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='cps',
    valueName='current',
    datasource="CMS Grafana Service",
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'DiskReadIOPS', 
      period: '60',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 20,
    y: 1,
  }
)
// 私网流出带宽
.addPanel(
  singlestat.new(
    '私网流出带宽',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='bps',
    valueName='current',
    datasource="CMS Grafana Service",
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'IntranetOutRate', 
      period: '60',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 12,
    y: 6,
  }
)
// 系统磁盘总写BPS
.addPanel(
  singlestat.new(
    '系统磁盘总写BPS',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='Bps',
    valueName='current',
    datasource="CMS Grafana Service",
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'DiskWriteBPS', 
      period: '60',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 16,
    y: 6,
  }
)
// 系统磁盘写IOPS
.addPanel(
  singlestat.new(
    '系统磁盘写IOPS',
    colors=[
        "#299c46",
        "rgba(237, 129, 40, 0.89)",
        "#d44a3a",
    ],
    format='cps',
    valueName='current',
    datasource="CMS Grafana Service",
    decimals=2,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'DiskWriteIOPS', 
      period: '60',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 5,
    w: 4,
    x: 20,
    y: 6,
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
      metric: 'cpu_total', 
      period: '15',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 4,
    x: 0,
    y: 4,
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
      metric: 'memory_usedutilization', 
      period: '15',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 4,
    x: 4,
    y: 3,
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
      metric: 'diskusage_utilization', 
      period: '15',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 4,
    x: 8,
    y: 3,
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
    y: 11,
  }
)
// 控制台链接
.addPanel(
  text.new(
      content='### [ECS 控制台](https://ecs.console.aliyun.com/)',
      mode='markdown',
      transparent=true,
  ),gridPos={
    x: 22,
    y: 11,
    w: 2,
    h: 2,
  }
)
// 基础资源
.addPanel(
  row.new(
    title='基础资源',
    repeat='name'
  )
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 13,
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
      metric: 'cpu_user', 
      period: '15',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 14,
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
      metric: 'memory_usedutilization', 
      period: '15',
      project: 'acs_ecs_dashboard',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 9,
    w: 12,
    x: 12,
    y: 14,
  }
)
// 系统负载
.addPanel(
    graph.new(
        '系统负载',
        x_axis_mode='time',
        formatY1='percent',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTargets(
      [
        {
          describe: 'load_1m',
          dimensions: ["$id"],
          group: '',
          metric: 'load_1m', 
          period: '15',
          project: 'acs_ecs_dashboard',
          target: ['Average'],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: ['Average']
        },
        {
          describe: 'load_5m',
          dimensions: ["$id"],
          group: '',
          metric: 'load_5m', 
          period: '15',
          project: 'acs_ecs_dashboard',
          target: ['Average'],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: ['Average']
        },
        {
          describe: 'load_15m',
          dimensions: ["$id"],
          group: '',
          metric: 'load_15m', 
          period: '15',
          project: 'acs_ecs_dashboard',
          target: ['Average'],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: ['Average']
        },
      ],
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 23,
  }
)
// 磁盘
.addPanel(
  row.new(
    title='磁盘',
    repeat='name',
    collapse=true,
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'diskusage_utilization', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 33,
  }
)
// 磁盘已用存储空间
.addPanel(
    graph.new(
        '磁盘已用存储空间',
        x_axis_mode='time',
        formatY1='decbytes',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
        {
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'diskusage_used', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 12,
    y: 33,
  }
)
// 磁盘已用存储空间
.addPanel(
    graph.new(
        '磁盘已用存储空间',
        x_axis_mode='time',
        formatY1='Bps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
        {
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'DiskWriteBPS', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 42,
  }
)
// 系统磁盘总读BPS
.addPanel(
    graph.new(
        '系统磁盘总读BPS',
        x_axis_mode='time',
        formatY1='Bps',
        formatY2='short',
        fill=1,
        legend_rightSide=true,
        legend_sideWidth=100,
        linewidth=1,
        pointradius=2,
    )
    .addTarget(
        {
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'DiskReadBPS', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 12,
    y: 42,
  }
)
// 系统磁盘读IOPS
.addPanel(
    graph.new(
        '系统磁盘读IOPS',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'DiskReadIOPS', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 51,
  }
)
// 系统磁盘写IOPS
.addPanel(
    graph.new(
        '系统磁盘写IOPS',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'DiskWriteIOPS', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 12,
    y: 51,
  }
)
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 32,
    }
)
// 网络
.addPanel(
  row.new(
    title='网络',
    repeat='name',
    collapse=true,
  )
// 私网流入带宽
.addPanel(
    graph.new(
        '私网流入带宽',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'IntranetInRate', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 34,
  }
)
// 私网流出带宽
.addPanel(
    graph.new(
        '私网流出带宽',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'IntranetOutRate', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 12,
    y: 34,
  }
)
// 网卡的上行带宽
.addPanel(
    graph.new(
        '网卡的上行带宽',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'networkin_rate', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 43,
  }
)
// 网卡的下行带宽
.addPanel(
    graph.new(
        '网卡的下行带宽',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'networkout_rate', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 12,
    y: 43,
  }
)
// 网卡每秒接收的数据包数
.addPanel(
    graph.new(
        '网卡每秒接收的数据包数',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'networkin_packages', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 52,
  }
)
// 网卡每秒发送的数据包数
.addPanel(
    graph.new(
        '网卡每秒发送的数据包数',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'networkout_packages', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 12,
    y: 52,
  }
)
// 设备驱动器检测到的接收错误包的数量
.addPanel(
    graph.new(
        '设备驱动器检测到的接收错误包的数量',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'networkin_errorpackages', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 0,
    y: 61,
  }
)
// 设备驱动器检测到的发送错误包的数量
.addPanel(
    graph.new(
        '设备驱动器检测到的发送错误包的数量',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'networkout_errorpackages', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 12,
    x: 12,
    y: 61,
  }
)
// TCP连接数
.addPanel(
    graph.new(
        'TCP连接数',
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
          describe: '',
          dimensions: ["$dimension"],
          group: '',
          metric: 'net_tcpconnection', 
          period: '900',
          project: 'acs_ecs_dashboard',
          target: [
            "Average",
            "Minimum",
            "Maximum",
          ],
          type: 'timeserie',
          xcol: 'timestamp',
          ycol: [
            "Average",
            "Minimum",
            "Maximum",
          ]
        },
    ), gridPos={
    h: 9,
    w: 24,
    x: 0,
    y: 70,
  }
)
  ,gridPos={
      h: 1,
      w: 24,
      x: 0,
      y: 33,
    }
)
