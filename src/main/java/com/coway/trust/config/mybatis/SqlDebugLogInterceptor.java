package com.coway.trust.config.mybatis;

import java.lang.reflect.Field;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.function.BiConsumer;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.BoundSql;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ParameterMapping;
import org.apache.ibatis.mapping.ResultSetType;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.mapping.StatementType;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.ReflectionUtils;

import com.coway.trust.biz.common.LargeExcelQuery;
import com.fasterxml.jackson.core.JsonProcessingException;

/*
 * Class Name : SqlDebugLogInterceptor
 * Description  : Local Parameter binding Sql Debug
 * Date           : 2019.08.18
 * Author        : jominjung
 */

@Intercepts({ @Signature(type = Executor.class, method = "update", args = { MappedStatement.class, Object.class }),
	                 @Signature(type = Executor.class, method = "query", args = { MappedStatement.class, Object.class,RowBounds.class, ResultHandler.class })
})
public class SqlDebugLogInterceptor implements Interceptor {

	private static final Logger LOGGER = LoggerFactory.getLogger(SqlDebugLogInterceptor.class);

	@Override
	public Object intercept(Invocation invocation) throws Throwable {

		Object[] args = invocation.getArgs();
		MappedStatement ms = (MappedStatement) args[0];

		// zaza20190818
		if(LOGGER.isDebugEnabled()){
			Object param = (Object)args[1];
			BoundSql boundSql = ms.getBoundSql(param);
			LOGGER.debug(">>>>>>>>>>> Parament Binding SQL : \n{}", getParameterBindingSQL(boundSql, param));
		}


		return invocation.proceed();
	}

	private boolean isNotLargeExcelQuery(String fullQueryId) {
		return LargeExcelQuery.get(getSimpleQueryId(fullQueryId)) == null;
	}

	private String getSimpleQueryId(String fullQueryId) {
		if (fullQueryId.lastIndexOf(".") != -1 && fullQueryId.lastIndexOf(".") != 0)
			return fullQueryId.substring(fullQueryId.lastIndexOf(".") + 1);
		else
			return "";
	}

	@Override
	public Object plugin(Object target) {
		return Plugin.wrap(target, this);
	}

	@Override
	public void setProperties(Properties properties) {
		// To change body of implemented methods use File | Settings | File Templates.
	}



	// zaza-20190818
	// Parameter Binding Sql
	public String getParameterBindingSQL(BoundSql boundSql, Object parameterObject) throws NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException, JsonProcessingException {

		StringBuilder sqlStringBuilder = new StringBuilder(boundSql.getSql());

		// stringBuilder 파라미터 replace 처리
		BiConsumer<StringBuilder, Object> sqlObjectReplace = (sqlSb, value) -> {

			int questionIdx = sqlSb.indexOf("?");

			if(questionIdx == -1) {
				return;
			}

			if(value == null) {
				sqlSb.replace(questionIdx, questionIdx + 1, "null");
			} else if (value instanceof String) {
				sqlSb.replace(questionIdx, questionIdx + 1, "'" + (value != null ? value.toString() : "") + "'");
			} else if(value instanceof Integer || value instanceof Long || value instanceof Float || value instanceof Double) {
				sqlSb.replace(questionIdx, questionIdx + 1, value.toString());
			} else if(value instanceof LocalDate || value instanceof LocalDateTime) {
				sqlSb.replace(questionIdx, questionIdx + 1, "'" + (value != null ? value.toString() : "") + "'");
			} else if(value instanceof Enum<?>) {
				sqlSb.replace(questionIdx, questionIdx + 1, "'" + (value != null ? value.toString() : "") + "'");
			} else {
				sqlSb.replace(questionIdx, questionIdx + 1, value.toString());
			}
		};

		if(parameterObject == null) {
			sqlObjectReplace.accept(sqlStringBuilder, null);
		} else {

			if(parameterObject instanceof Integer || parameterObject instanceof Long || parameterObject instanceof Float || parameterObject instanceof Double || parameterObject instanceof String) {
				sqlObjectReplace.accept(sqlStringBuilder, parameterObject);
			} else if(parameterObject instanceof Map) {

				Map paramterObjectMap = (Map)parameterObject;
				List<ParameterMapping> paramMappings = boundSql.getParameterMappings();

				for (ParameterMapping parameterMapping : paramMappings) {
					String propertyKey = parameterMapping.getProperty();

					try {
						Object paramValue = null;
						if(boundSql.hasAdditionalParameter(propertyKey)) {
							// 동적 SQL로 인해 __frch_item_0 같은 파라미터가 생성되어 적재됨, additionalParameter로 획득
							paramValue = boundSql.getAdditionalParameter(propertyKey);
						} else {
							paramValue = paramterObjectMap.get(propertyKey);
						}

						sqlObjectReplace.accept(sqlStringBuilder, paramValue);
					} catch (Exception e) {
						sqlObjectReplace.accept(sqlStringBuilder, "[cannot binding : " + propertyKey+ "]");
					}

				}
			} else {

				List<ParameterMapping> paramMappings = boundSql.getParameterMappings();
				Class< ? extends Object> paramClass = parameterObject.getClass();

				for (ParameterMapping parameterMapping : paramMappings) {
					String propertyKey = parameterMapping.getProperty();

					try {

						Object paramValue = null;
						if(boundSql.hasAdditionalParameter(propertyKey)) {
							// 동적 SQL로 인해 __frch_item_0 같은 파라미터가 생성되어 적재됨, additionalParameter로 획득
							paramValue = boundSql.getAdditionalParameter(propertyKey);
						} else {
							Field field = ReflectionUtils.findField(paramClass, propertyKey);
							field.setAccessible(true);
							paramValue = field.get(parameterObject);
						}

						sqlObjectReplace.accept(sqlStringBuilder, paramValue);
					} catch (Exception e) {
						sqlObjectReplace.accept(sqlStringBuilder, "[cannot binding : " + propertyKey+ "]");
					}
				}
			}
		}

		return sqlStringBuilder.toString();
	}

}
