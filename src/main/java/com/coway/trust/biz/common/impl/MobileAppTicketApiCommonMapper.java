package com.coway.trust.biz.common.impl;

import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

@Mapper("mobileAppTicketApiCommonMapper")
public interface MobileAppTicketApiCommonMapper {

  int selectMobTicketNo();

  /**
   * insert
   *
   * @Author KR-HAN
   * @Date 2019. 10. 11.
   * @param params
   */
  void insert(Map<String, Object> params);

  /**
   * update
   *
   * @Author KR-HAN
   * @Date 2019. 10. 11.
   * @param params
   */
  int update(Map<String, Object> params);

  String getCustNm(Map<String, Object> params);
}
