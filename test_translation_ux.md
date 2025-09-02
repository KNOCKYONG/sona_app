# Translation Toggle UX Test Plan

## Test Scenarios

### 1. Basic Toggle Test
- [ ] Tap to show translation - should fade in smoothly
- [ ] Tap to hide translation - should fade out smoothly
- [ ] Animation should complete in ~250ms

### 2. Rapid Toggle Test
- [ ] Toggle rapidly 5 times - animations should not stack or glitch
- [ ] Each toggle should feel responsive

### 3. Long Translation Test
- [ ] Test with English translation 2x longer than Korean
- [ ] Bubble should expand smoothly downward
- [ ] Messages below should move naturally

### 4. Short Translation Test
- [ ] Test with Chinese translation shorter than Korean
- [ ] Bubble should maintain size or shrink slightly
- [ ] No unnecessary whitespace

### 5. Scroll Position Test
- [ ] Toggle translation in middle of conversation
- [ ] Check if reading position is maintained
- [ ] Viewport should not jump

### 6. Performance Test
- [ ] Test with 50+ messages in conversation
- [ ] Animations should remain smooth
- [ ] No lag or frame drops

## Expected UX Metrics
- Animation smoothness: 60 FPS
- Response time: < 50ms from tap
- Total animation: ~250ms
- User satisfaction: Natural, not distracting

## Known Considerations
1. **Scroll jump**: Minor viewport shift is acceptable if content changes significantly
2. **Memory usage**: AnimatedSwitcher adds slight overhead but improves UX
3. **Battery impact**: Minimal due to short animation duration