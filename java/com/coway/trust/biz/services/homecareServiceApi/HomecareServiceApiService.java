package com.coway.trust.biz.services.homecareServiceApi;

import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.as.HomecareAfterServiceApiForm;
import com.coway.trust.api.mobile.services.installation.HomecareServiceApiForm;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName :
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 11. 13.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
public interface HomecareServiceApiService {

	List<EgovMap> selectPartnerCode (HomecareServiceApiForm param);

	List<EgovMap> selectAsPartnerCode (HomecareAfterServiceApiForm param);

}
