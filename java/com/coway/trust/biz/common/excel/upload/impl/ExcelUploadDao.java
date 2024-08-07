package com.coway.trust.biz.common.excel.upload.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import com.coway.trust.web.common.excel.upload.ExcelUploadDBHandler;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ExcelUploadDao implements ExcelUploadDBHandler {

	@Resource(name = "sqlSessionTemplateBatch")
	private SqlSessionTemplate sqlSessionTemplateBatch;

	@Override
	public void processDB(String queryId, List<Map<String, Object>> dataMapList) {
		for (Map<String, Object> data : dataMapList) {
			sqlSessionTemplateBatch.update(queryId, data);
		}
	}
}
