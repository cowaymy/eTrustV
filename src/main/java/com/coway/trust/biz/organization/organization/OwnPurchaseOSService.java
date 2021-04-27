package com.coway.trust.biz.organization.organization;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public interface OwnPurchaseOSService {
    EgovMap getOrgDtls(Map<String, Object> params);
    List<EgovMap> searchOwnPurchase(Map<String, Object> params);
}
