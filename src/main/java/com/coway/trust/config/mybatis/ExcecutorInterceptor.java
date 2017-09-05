package com.coway.trust.config.mybatis;

import java.util.Properties;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ResultSetType;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;

@Intercepts({ @Signature(type = Executor.class, method = "query", args = { MappedStatement.class, Object.class,
		RowBounds.class, ResultHandler.class }) })
public class ExcecutorInterceptor implements Interceptor {

	@Override
	public Object intercept(Invocation invocation) throws Throwable {

		Object[] args = invocation.getArgs();
		MappedStatement ms = (MappedStatement) args[0];

		if (SqlCommandType.SELECT == ms.getSqlCommandType()) {
			String[] keyPropertyies = ms.getKeyProperties();
			String keyProperty = keyPropertyies == null ? "" : String.join(",", String.join(",", keyPropertyies));

			String[] keyColumns = ms.getKeyColumns();
			String keyColumn = keyColumns == null ? "" : String.join(",", keyColumns);

			String[] resultSets = ms.getResulSets();
			String resultSet = resultSets == null ? "" : String.join(",", resultSets);

			MappedStatement.Builder builder = new MappedStatement.Builder(ms.getConfiguration(), ms.getId(),
					ms.getSqlSource(), ms.getSqlCommandType());
			builder.resource(ms.getResource()).parameterMap(ms.getParameterMap()).resultMaps(ms.getResultMaps())
					.fetchSize(ms.getFetchSize()).timeout(ms.getTimeout()).statementType(ms.getStatementType())
					.cache(ms.getCache()).flushCacheRequired(ms.isFlushCacheRequired()).useCache(ms.isUseCache())
					.resultOrdered(ms.isResultOrdered()).keyGenerator(ms.getKeyGenerator()).keyProperty(keyProperty)
					.keyColumn(keyColumn).resulSets(resultSet).databaseId(ms.getDatabaseId()).lang(ms.getLang())
					.resultSetType(ResultSetType.SCROLL_INSENSITIVE);
			args[0] = builder.build();
		}

		return invocation.proceed();
	}

	@Override
	public Object plugin(Object target) {
		return Plugin.wrap(target, this);
	}

	@Override
	public void setProperties(Properties properties) {
		// To change body of implemented methods use File | Settings | File Templates.
	}

}
