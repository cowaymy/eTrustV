package com.coway.trust.util;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;
import org.springframework.jdbc.support.nativejdbc.CommonsDbcpNativeJdbcExtractor;

import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;

public class OracleCallBackHandler implements TypeHandler<Object>{
	 
	 @Override
	 public Object getResult(ResultSet rs, String columnName) throws SQLException {
	  // TODO Auto-generated method stub
	  String value = "";
	  //System.out.println("columnName :: " + value);
	  return value;
	 }
	 
	 @Override
	 public Object getResult(CallableStatement cs, int columnIndex) throws SQLException {
	  // TODO Auto-generated method stub
	  //System.out.println("columnIndex :: " + cs.getString(columnIndex));
	  return cs.getString(columnIndex);
	 }
	 
	 @Override
	 public void setParameter(PreparedStatement ps, int i, Object parameter,
	   JdbcType arg3) throws SQLException {
	 
	  CommonsDbcpNativeJdbcExtractor extractor = new CommonsDbcpNativeJdbcExtractor();
	  Connection conn = extractor.getNativeConnection(ps.getConnection());
	  // TODO Auto-generated method stub
	  ArrayDescriptor desc = ArrayDescriptor.createDescriptor("ARRAY_TABLE", conn);
	  //parameter = new ARRAY(desc, conn, ((ArrayList) parameter).toArray());
	  parameter = new ARRAY(desc, conn, (String[])parameter);
	  ps.setArray(i, (oracle.sql.ARRAY)parameter);
	 }

	@Override
	public Object getResult(ResultSet rs, int columnIndex) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}
	 
	}
