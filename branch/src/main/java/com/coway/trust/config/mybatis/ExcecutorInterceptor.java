package com.coway.trust.config.mybatis;

import java.util.Properties;

import org.apache.ibatis.executor.Executor;
import org.apache.ibatis.mapping.MappedStatement;
import org.apache.ibatis.mapping.ResultSetType;
import org.apache.ibatis.mapping.SqlCommandType;
import org.apache.ibatis.mapping.StatementType;
import org.apache.ibatis.plugin.*;
import org.apache.ibatis.session.ResultHandler;
import org.apache.ibatis.session.RowBounds;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.coway.trust.biz.common.LargeExcelQuery;

@Intercepts({ @Signature(type = Executor.class, method = "query", args = { MappedStatement.class, Object.class,
		RowBounds.class, ResultHandler.class }) })
public class ExcecutorInterceptor implements Interceptor {

	private static final Logger LOGGER = LoggerFactory.getLogger(ExcecutorInterceptor.class);

	@Override
	public Object intercept(Invocation invocation) throws Throwable {

		Object[] args = invocation.getArgs();
		MappedStatement ms = (MappedStatement) args[0];

		if (ms != null){
			LOGGER.debug("id : {}", ms.getId());
			LOGGER.debug("SqlCommandType : {}", ms.getSqlCommandType());
			LOGGER.debug("StatementType : {}", ms.getStatementType());
		}else{
			LOGGER.debug("MappedStatement is null....");
		}

		if (ms != null && SqlCommandType.SELECT == ms.getSqlCommandType()
				&& StatementType.CALLABLE != ms.getStatementType() && isNotLargeExcelQuery(ms.getId())) {
			String[] keyProperties = ms.getKeyProperties();
			String keyProperty = keyProperties == null ? "" : String.join(",", String.join(",", keyProperties));

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

}
