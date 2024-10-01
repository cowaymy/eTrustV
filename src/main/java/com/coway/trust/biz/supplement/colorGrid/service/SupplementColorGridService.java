package com.coway.trust.biz.supplement.colorGrid.service;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface SupplementColorGridService {
  List<EgovMap> colorGridList( Map<String, Object> params );

  List<EgovMap> selectProductCategoryList();

  List<EgovMap> colorGridCmbProduct();

  String getMemID( Map<String, Object> params );

  List<EgovMap> selectCodeList();

  List<EgovMap> getSupplementDetailList( Map<String, Object> params ) throws Exception;

  List<EgovMap> selectSupRefStus();
}
