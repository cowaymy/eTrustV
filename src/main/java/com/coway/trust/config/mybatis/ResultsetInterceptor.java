package com.coway.trust.config.mybatis;

import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Properties;

import org.apache.ibatis.executor.resultset.ResultSetHandler;
import org.apache.ibatis.plugin.*;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;

@Intercepts({ @Signature(type = ResultSetHandler.class, method = "handleResultSets", args = { Statement.class }) })
public class ResultsetInterceptor implements Interceptor {

	@Override
	public Object intercept(Invocation invocation) throws Throwable {

		Object[] args = invocation.getArgs();

		Statement statement = (Statement) args[0];

		ResultSet rs = statement.getResultSet();
		// ResultSetMetaData rsmd = rs.getMetaData();

		if (rs.getType() == ResultSet.TYPE_SCROLL_INSENSITIVE && rs.last()) {
			int rowCount = rs.getRow();

			if (rowCount > AppConstants.RECORD_MAX_SIZE) {
				throw new ApplicationException(AppConstants.FAIL, "Too many rows...Please add search condition....");
			}

			rs.beforeFirst();
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
