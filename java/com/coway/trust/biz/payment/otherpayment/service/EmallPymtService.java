package com.coway.trust.biz.payment.otherpayment.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface EmallPymtService
{
  List<EgovMap> selectEmallPymtList(Map<String, Object> params);

  List<EgovMap> selectEmallPymtDetailsList(Map<String, Object> params);

  EgovMap executeAdvPymtTesting(Map<String, Object> params, HttpServletResponse response)  throws Exception;

  EgovMap executeAdvPymt(Map<String, Object> params, HttpServletResponse response)  throws Exception;

  EgovMap excelFileProcess(Map<String, Object> params);

  EgovMap moveFileLocal(Map<String, Object> params);
}
