package mono.context;

enum ConsumerCommand {
	APPLY_FROM_CONTEXT(f:(context:context.Context) -> Void);
	APPLY_TO_CONTEXT(f:(context:context.Context) -> Void);
}