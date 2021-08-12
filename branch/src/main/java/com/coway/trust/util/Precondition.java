package com.coway.trust.util;

import javax.annotation.Nullable;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.PreconditionException;

public class Precondition {
	private Precondition() {}

	public static void checkArgument(boolean expression) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, "IllegalArgumentException");
		}
	}

	public static void checkArgument(boolean expression, @Nullable Object errorMessage) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, String.valueOf(errorMessage));
		}
	}

	public static void checkArgument(boolean expression, @Nullable String propertyKey) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, propertyKey);
		}
	}

	public static void checkArgument(boolean expression, @Nullable String errorMessageTemplate,
			@Nullable Object... errorMessageArgs) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, format(errorMessageTemplate, errorMessageArgs));
		}
	}

	public static void checkState(boolean expression) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, "IllegalStateException");
		}
	}

	public static void checkState(boolean expression, @Nullable Object errorMessage) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, String.valueOf(errorMessage));
		}
	}

	public static void checkState(boolean expression, @Nullable String propertyKey) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, propertyKey);
		}
	}

	public static void checkState(boolean expression, @Nullable String errorMessageTemplate,
			@Nullable Object... errorMessageArgs) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, format(errorMessageTemplate, errorMessageArgs));
		}
	}

	public static <T> T checkNotNull(T reference) {
		if (reference == null) {
			throw new PreconditionException(AppConstants.FAIL, "NullPointerException");
		} else {
			return reference;
		}
	}

	public static <T> T checkNotNull(T reference, @Nullable Object errorMessage) {
		if (reference == null) {
			throw new PreconditionException(AppConstants.FAIL, String.valueOf(errorMessage));
		} else {
			return reference;
		}
	}

	public static void checkNotNull(boolean expression, @Nullable String propertyKey) {
		if (!expression) {
			throw new PreconditionException(AppConstants.FAIL, propertyKey);
		}
	}

	public static <T> T checkNotNull(T reference, @Nullable String errorMessageTemplate,
			@Nullable Object... errorMessageArgs) {
		if (reference == null) {
			throw new PreconditionException(AppConstants.FAIL, format(errorMessageTemplate, errorMessageArgs));
		} else {
			return reference;
		}
	}

	static String format(String pTemplate, @Nullable Object... args) {
		String template = String.valueOf(pTemplate);// null => "null"
		StringBuilder builder = new StringBuilder(template.length() + 16 * args.length);
		int templateStart = 0;

		int i;
		int placeholderStart;
		for (i = 0; i < args.length; templateStart = placeholderStart + 2) {
			placeholderStart = template.indexOf("%s", templateStart);
			if (placeholderStart == -1) {
				break;
			}

			builder.append(template.substring(templateStart, placeholderStart));
			builder.append(args[i++]);
		}

		builder.append(template.substring(templateStart));
		if (i < args.length) {
			builder.append(" [");
			builder.append(args[i++]);

			while (i < args.length) {
				builder.append(", ");
				builder.append(args[i++]);
			}

			builder.append(']');
		}

		return builder.toString();
	}
}
