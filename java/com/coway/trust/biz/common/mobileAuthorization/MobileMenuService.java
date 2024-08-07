package com.coway.trust.biz.common.mobileAuthorization;

import java.util.List;
import java.util.Map;

import com.coway.trust.web.common.CommStatusVO;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MobileMenuService.java
 * @Description : MobileMenuService
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 30.   KR-HAN        First creation
 * </pre>
 */
@SuppressWarnings("unused")
public interface MobileMenuService {

	 /**
	 * 모바일 메뉴 조회
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMobileMenuList(Map<String, Object> params);

	 /**
	 * 모바일 메뉴 저장
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param addList
	 * @param udtList
	 * @param delList
	 * @param userId
	 * @return
	 */
	int saveMobileMenu(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId);

	 /**
	 * 모바일 메뉴 팝업 조회
	 * @Author KR-HAN
	 * @Date 2019. 10. 30.
	 * @param params
	 * @return
	 */
	List<EgovMap> selectMobileMenuPopList(Map<String, Object> params);
}
