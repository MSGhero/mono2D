package mono.context;

enum ConsumerCommand {
	INIT_CONTEXT(ctx:context.Context);
	APPLY_FROM_CONTEXT(f:(context:context.Context) -> Void);
	APPLY_TO_CONTEXT(f:(context:context.Context) -> Void);
}