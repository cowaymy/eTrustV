package com.coway.trust.biz.services.servicePlanning;

import java.util.List;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MagicAddressService.java
 * @Description : Magic Address Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 3.   KR-SH        First creation
 * </pre>
 */
public interface MagicAddressService {

	/**
	 * Search Magic Address
	 * @Author KR-SH
	 * @Date 2019. 12. 3.
	 * @param params
	 * @return
	 */
	public List<EgovMap>  selectMagicAddress(Map<String, Object> params);

}
