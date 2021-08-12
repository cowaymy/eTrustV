/**
 *
 */
package com.coway.trust.biz.logistics.serialChange;

import java.util.Map;

/**
 * @ClassName : SerialChangeService.java
 * @Description : SerialChangeService
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 16.   KR-HAN        First creation
 * </pre>
 */
public interface SerialChangeService {

	// KR HAN : Save Serial No Modify
	Map<String, Object> saveSerialNoModify(Map<String, Object> params);
}
