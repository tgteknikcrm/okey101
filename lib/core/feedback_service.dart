/// Tactile feedback, behind an interface.
///
/// `HapticFeedback` silently does nothing on the web, and the Vibration API
/// does not exist in iOS Safari at all. Rather than sprinkle calls that will
/// never fire through the widgets, everything goes through here and the web
/// build gets the no-op implementation.
abstract class FeedbackService {
  const FeedbackService();

  /// Picking a tile up.
  void selection();

  /// Dropping a tile into a slot.
  void light();

  /// Laying a meld, going out.
  void medium();

  /// An illegal move.
  void error();
}

/// The web implementation: does nothing, on purpose.
class NoopFeedbackService extends FeedbackService {
  const NoopFeedbackService();

  @override
  void selection() {}

  @override
  void light() {}

  @override
  void medium() {}

  @override
  void error() {}
}
