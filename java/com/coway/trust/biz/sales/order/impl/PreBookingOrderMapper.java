/*
 * Copyright 2011 MOPAS(Ministry of Public Administration and Security).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.coway.trust.biz.sales.order.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.sales.order.vo.PreBookingOrderVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("preBookingOrderMapper")
public interface PreBookingOrderMapper {

  // Search Pre OrderList
  public List<EgovMap> selectPreBookingOrderList(Map<String, Object> params);

  EgovMap selectPreBookOrderEligibleInfo(Map<String, Object> params);

  String selectNextPreBookingNo();

  void updatePreBookingNo(Map<String, Object> params);

  public int insertPreBooking(PreBookingOrderVO preBookingOrderVO);

  public EgovMap selectPreBookingOrderInfo(Map<String, Object> params);

  public int updatePreBookOrderCancel(Map<String, Object> params);

  List<EgovMap> selectPreBookOrderCancelStatus(Map<String, Object> params);

  String getPreBookingSmsTemplate(Map<String, Object> params);

  List<EgovMap> selectPrevOrderNoList(Map<String, Object> params);

  EgovMap selectPreBookSalesPerson(Map<String, Object> params);

  EgovMap selectPreBookConfigurationPerson(Map<String, Object> params);

  EgovMap selectPreBookOrdDtlWA(Map<String, Object> params);

  public int selectPreBookOrdById(Map<String, Object> params);

  public void updatePreBookOrderCustVerifyStus(Map<String, Object> params);

  EgovMap selectPreBookOrderEligibleCheck(Map<String, Object> params);

}
