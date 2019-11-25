package com.coway.trust.biz.common.mobileMenu;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @ClassName : MobileMenuApiService.java
 * @Description : MobileMenuApiService
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 1.   KR-HAN        First creation
 * </pre>
 */
public interface MobileMenuApiService{

	 /**
	 * selectMobileMenuList
	 * @Author KR-HAN
	 * @Date 2019. 11. 1.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMobileMenuList(Map<String, Object> params);

}
