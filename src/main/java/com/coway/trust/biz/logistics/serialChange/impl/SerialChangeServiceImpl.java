/**
 *
 */
package com.coway.trust.biz.logistics.serialChange.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serialChange.SerialChangeService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;


/**
 * @ClassName : SerialChangeServiceImpl.java
 * @Description : SerialChangeServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 16.   KR-HAN        First creation
 * </pre>
 */
@Service("serialChangeService")
public class SerialChangeServiceImpl extends EgovAbstractServiceImpl implements SerialChangeService {

  private static Logger logger = LoggerFactory.getLogger(SerialChangeServiceImpl.class);

  @Resource(name = "serialChangeMapper")
  private SerialChangeMapper serialChangeMapper;

	// KR HAN
  @SuppressWarnings("unchecked")
  @Override
	public Map<String, Object> saveSerialNoModify(Map<String, Object> params) {

	logger.info("++++ saveSerialNoModify params ::" + params );

	params.put("pItmCode", params.get("pStkCode") );
	params.put("pRefDocNo", params.get("pRetnNo") );
	params.put("pCallGbn", "RETURN" );
	params.put("pMobileYn", "Y" );

	params.put("pUserId", CommonUtils.intNvl(params.get("userId"))  );

	serialChangeMapper.updateBarcodeChange(params);

	logger.info("++++ saveSerialNoModify return params ::" + params );

  	  return params;
	}
}
