abstract class IViewLifecycle {
  void initState();

  void afterBuild(Duration timestamp);

  void didChangeDependencies();

  void didUpdateWidgets<W>(W oldWidget);

  void deactivate();

  void dispose();
}
