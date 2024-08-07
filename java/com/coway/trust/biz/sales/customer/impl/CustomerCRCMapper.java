package com.coway.trust.biz.sales.customer.impl;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("customerCRCMapper")
public interface CustomerCRCMapper {

    List<EgovMap> getCardDetails();

}
