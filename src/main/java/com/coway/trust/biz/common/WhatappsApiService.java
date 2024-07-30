package com.coway.trust.biz.common;

import java.util.Map;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public interface WhatappsApiService {

	Map<String, Object> preBookWhatappsReqApi(Map<String, Object> params);

	EgovMap verifyBasicAuth(Map<String, Object> params, HttpServletRequest request);

	void rtnRespMsg(Map<String, Object> params);

	Map<String, Object> setWaTemplateConfiguration(Map<String, Object> params);

}