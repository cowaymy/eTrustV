package com.coway.trust.biz.common.mobileAuthorization;

import java.util.List;
import java.util.Map;

import com.coway.trust.web.common.CommStatusVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@SuppressWarnings("unused")
public interface MobileAuthMenuService {

	List<EgovMap> selectMobileRoleAuthMappingAdjustList(Map<String, Object> params);

	int saveMobileMenuAuthRoleMapping(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId);
}
