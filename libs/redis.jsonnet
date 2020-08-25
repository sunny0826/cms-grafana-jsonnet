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
    'Redis监控',
    schemaVersion=20,
    tags=['redis','阿里云'],
    refresh='5m',
    hideControls=true,
)
// Variables
.addTemplate(
    template.new(
        name='name',
        label='实例名称',
        datasource='Variable DataSource',
        query='redis',
        refresh='load',
    )
)
.addTemplate(
    template.new(
        name='id',
        datasource='Variable DataSource',
        query='redis($name)',
        refresh='load',
        hide=2,
    )
)
.addTemplate(
    template.custom(
      'cmd',
      'Standardappend,Standardbitcount,Standardbitop,Standardblpop,Standardbrpop,Standardbrpoplpush,Standarddecr,Standarddecrby,Standarddel,Standarddiscard,Standarddump,Standardexec,Standardexists,Standardexpire,Standardexpireat,StandardFailedCount,Standardget,Standardgetbit,Standardgetrange,Standardgetset,Standardhdel,Standardhexists,Standardhget,Standardhgetall,Standardhincrby,Standardhincrbyfloat,Standardhkeys,Standardhlen,Standardhmget,Standardhmset,Standardhscan,Standardhset,Standardhsetnx,Standardhvals,Standardincr,Standardincrby,Standardincrbyfloat,Standardlindex,Standardlinsert,Standardllen,Standardlpop,Standardlpush,Standardlpushx,Standardlrange,Standardlrem,Standardlset,Standardltrim,Standardmget,Standardmove,Standardmset,Standardmsetnx,Standardmulti,Standardpersist,Standardpexpire,Standardpexpireat,Standardpfadd,Standardpfcount,Standardpfmerge,Standardpsetex,Standardpsubscribe,Standardpttl,Standardpublish,Standardpubsub,Standardpunsubscribe,Standardrandomkey,Standardrename,Standardrenamenx,Standardrestore,Standardrpop,Standardrpoplpush,Standardrpush,Standardrpushx,Standardsadd,Standardscan,Standardscard,Standardsdiff,Standardsdiffstore,Standardset,Standardsetbit,Standardsetex,Standardsetnx,Standardsetrange,Standardsinter,Standardsinterstore,Standardsismember,Standardsmembers,Standardsmove,Standardsort,Standardspop,Standardsrandmember,Standardsrem,Standardsscan,Standardstrlen,Standardsubscribe,Standardsunion,Standardsunionstore,Standardttl,Standardtype,Standardunsubscribe,Standardunwatch,Standardwatch,Standardzadd,Standardzcard,Standardzcount,Standardzincrby,Standardzinterstore,Standardzlexcount,Standardzrange,Standardzrangebylex,Standardzrangebyscore,Standardzrank,Standardzrem,Standardzremrangebylex,Standardzremrangebyrank,Standardzremrangebyscore,Standardzrevrange,Standardzrevrangebyscore,Standardzrevrank,Standardzscan,Standardzscore,Standardzunionstore',
      'Standardappend',
      label='命令',
      refresh='load',
    )
)
// row 概览
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
      metric: 'StandardCpuUsage', 
      period: '60',
      project: 'acs_kvstore',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
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
      metric: 'StandardMemoryUsage', 
      period: '60',
      project: 'acs_kvstore',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 4,
    x: 4,
    y: 1,
  }
)
// QPS使用率
.addPanel(
  gauge.new(
    'QPS使用率',
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
      metric: 'StandardQPSUsage', 
      period: '300',
      project: 'acs_kvstore',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 4,
    x: 8,
    y: 1,
  }
)
// 流出带宽使用率
.addPanel(
  gauge.new(
    '流出带宽使用率',
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
      metric: 'StandardIntranetOutRatio', 
      period: '300',
      project: 'acs_kvstore',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 4,
    x: 12,
    y: 1,
  }
)
// 流入带宽使用率
.addPanel(
  gauge.new(
    '流入带宽使用率',
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
      metric: 'StandardIntranetInRatio', 
      period: '300',
      project: 'acs_kvstore',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 8,
    w: 4,
    x: 16,
    y: 1,
  }
)
// 平均响应时间
.addPanel(
  singlestat.new(
    '',
    format='µs',
    valueName='current',
    datasource="CMS Grafana Service",
    colorBackground=false,
    decimals=2,
    postfixFontSize='50%',
    prefixFontSize='50%',
    prefix='平均响应时间',
    sparklineShow=true,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'StandardAvgRt', 
      period: '60',
      project: 'acs_kvstore',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 4,
    w: 4,
    x: 20,
    y: 1,
  }
)
// 缓存内Key数量
.addPanel(
  singlestat.new(
    '',
    format='none',
    valueName='current',
    datasource="CMS Grafana Service",
    colorBackground=false,
    decimals=2,
    postfixFontSize='50%',
    prefixFontSize='50%',
    prefix='缓存内Key数量',
    sparklineShow=true,
  )
  .addTarget(
    {
      group: '',
      dimensions: ["$id"],
      metric: 'StandardKeys', 
      period: '60',
      project: 'acs_kvstore',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
    },
  ), gridPos={
    h: 4,
    w: 4,
    x: 20,
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
      content='### [Redis 控制台](https://kvstorenext.console.aliyun.com/)',
      mode='markdown',
      transparent=true,
  ),gridPos={
    h: 2,
    w: 2,
    x: 22,
    y: 9,
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
      y: 11,
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
      metric: 'StandardCpuUsage', 
      period: '60',
      project: 'acs_kvstore',
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
      metric: 'StandardMemoryUsage', 
      period: '60',
      project: 'acs_kvstore',
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
// $cmd 命令的执行频率
.addPanel(
    graph.new(
        '$cmd 命令的执行频率',
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
      dimensions: ["$id"],
      group: '',
      metric: '$cmd', 
      period: '60',
      project: 'acs_kvstore',
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
// 缓存内Key数量
.addPanel(
    graph.new(
        '缓存内Key数量',
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
      metric: 'StandardKeys', 
      period: '60',
      project: 'acs_kvstore',
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
      metric: 'StandardConnectionUsage', 
      period: '60',
      project: 'acs_kvstore',
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
// 连接数使用率
.addPanel(
    graph.new(
        '平均响应时间',
        x_axis_mode='time',
        formatY1='µs',
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
      metric: 'StandardAvgRt', 
      period: '60',
      project: 'acs_kvstore',
      target: ['Average'],
      type: 'timeserie',
      xcol: 'timestamp',
      ycol: ['Average']
      },
    ), gridPos={
    h: 8,
    w: 12,
    x: 12,
    y: 28,
  }
)
// 流入带宽使用率
.addPanel(
    graph.new(
        '流入带宽使用率',
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
      metric: 'StandardIntranetInRatio', 
      period: '60',
      project: 'acs_kvstore',
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
// 流出带宽使用率
.addPanel(
    graph.new(
        '流出带宽使用率',
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
      metric: 'StandardIntranetOutRatio', 
      period: '60',
      project: 'acs_kvstore',
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