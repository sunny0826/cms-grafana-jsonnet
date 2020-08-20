{
  /**
   * @name theme.new
   */
  new(
    activeThemeId=1,
    theme=[],
  )::
    {
      activeThemeId: activeThemeId,
      title: '',
      timeFrom: null,
      timeShift: null,
      transparent: true,
      type: 'yesoreyeram-boomtheme-panel',
      _nextTheme:: 0,
      addTheme(name,url="",bgimage="",style=""):: self {
        local nextTheme = super._nextTheme,
        local theme = {
          name: name,
          styles: [
            {
            props: {
                theme: "default"
              },
              type: "basetheme"
            },
            {
              props: {
                url: bgimage
              },
              type: "bgimage"
            },
            {
              props: {
                  url: url
                },
                type: "url"
            },
            {
              props: {
                text: style
              },
              type: "style"
            },
          ],
        },
        _nextTheme: nextTheme + 1,
        themes+: [theme],
      },
    }
}
