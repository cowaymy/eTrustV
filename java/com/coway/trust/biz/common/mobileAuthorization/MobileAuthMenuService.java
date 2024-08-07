package com.coway.trust.biz.common.mobileAuthorization;

import java.util.List;
import java.util.Map;

import com.coway.trust.web.common.CommStatusVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileAuthMenuService.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 9.   KR-HAN        First creation
 * </pre>
 */
@SuppressWarnings("unused")
public interface MobileAuthMenuService {

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 12. 9.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMobileRoleAuthMappingAdjustList(Map<String, Object> params);

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 12. 9.
	 * @param addList
	 * @param udtList
	 * @param delList
	 * @param userId
	 * @return
	 */
	int saveMobileMenuAuthRoleMapping(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId);

	 /**
	 * TO-DO Description
	 * @Author KR-HAN
	 * @Date 2019. 12. 9.
	 * @param params
	 * @param userId
	 * @return
	 */
	int saveMobileMenuAuthAllRoleMapping(Map<String, Object> params, Integer userId);

	List<EgovMap> selectMobileMenuAuthMenuList(Map<String, Object> params);
}
