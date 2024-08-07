package com.coway.trust.biz.api;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CMSApiService {
    EgovMap genCsvFile(HttpServletRequest request, Map<String, Object> params) throws Exception;
}
