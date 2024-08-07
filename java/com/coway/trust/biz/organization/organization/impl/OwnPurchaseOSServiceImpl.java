package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.OwnPurchaseOSService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("OwnPurchaseOSService")
public class OwnPurchaseOSServiceImpl implements OwnPurchaseOSService {

    @Resource(name = "OwnPurchaseOSMapper")
    private OwnPurchaseOSMapper ownPurchaseOSMapper;

    @Override
    public EgovMap getOrgDtls(Map<String, Object> params) {
        return ownPurchaseOSMapper.getOrgDtls(params);
    }

    @Override
    public List<EgovMap> searchOwnPurchase(Map<String, Object> params) {
        return ownPurchaseOSMapper.searchOwnPurchase(params);
    }
}
