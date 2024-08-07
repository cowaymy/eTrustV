package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;

import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface CustomerScoreCardService {

  /**
   * 글 목록을 조회한다.
   *
   * @param searchVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  List<EgovMap> customerScoreCardList(Map<String, Object> params);
  String getMemType(Map<String, Object> params);

}
