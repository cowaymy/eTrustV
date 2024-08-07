package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;
import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("customerScoreCardMapper")
public interface CustomerScoreCardMapper {

  /**
   * 글 목록을 조회한다.
   *
   * @param searchVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  List<EgovMap> customerScoreCardList(Map<String, Object> params);
  EgovMap getLatestBillNo(Map<String, Object> params);
  String getMemType(Map<String, Object> params);

}
