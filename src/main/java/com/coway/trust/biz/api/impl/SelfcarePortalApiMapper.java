package com.coway.trust.biz.api.impl;

import java.util.List;
import java.util.Map;

import com.coway.trust.biz.api.vo.selfcarePortal.ProductDetailVO;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Mapper("SelfcarePortalApiMapper")
public interface SelfcarePortalApiMapper
{

    List<EgovMap> checkOrderNo( EgovMap params );
    EgovMap selectProductDetail(Map<String, Object> params);
    EgovMap selectMembershipDetail(Map<String, Object> params);
    EgovMap selectServiceList(Map<String, Object> params);
    List<EgovMap> selectFilterInfo(Map<String, Object> params);
    EgovMap selectUpcomingServices(Map<String, Object> params);
}
