/**
 *
 */
package com.coway.trust.biz.logistics.serialHistory.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.coway.trust.biz.logistics.serialChange.impl.SerialChangeServiceImpl;
import com.coway.trust.biz.logistics.serialHistory.SerialHistoryService;
import com.crystaldecisions.jakarta.poi.util.StringUtil;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialHistoryServiceImpl.java
 * @Description : SerialHistoryServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 12. 21.   KR-HAN        First creation
 * </pre>
 */
@Service("serialHistoryService")
public class SerialHistoryServiceImpl extends EgovAbstractServiceImpl implements SerialHistoryService {

  private static Logger logger = LoggerFactory.getLogger(SerialChangeServiceImpl.class);

  @Resource(name = "serialHistoryMapper")
  private SerialHistoryMapper serialHistoryMapper;


    /**
     * 시리얼 이력 조회
     * @Author KR-HAN
     * @Date 2019. 12. 21.
     * @param params
     * @return
     * @see com.coway.trust.biz.logistics.serialHistory.SerialHistoryService#selectSerialHistoryList(java.util.Map)
     */
    @Override
	public List<EgovMap> selectSerialHistoryList(Map<String, Object> params) {

    	logger.info("++++ selectSerialHistoryList params :: {}", params );

//    	logger.info("++++ serialNo ::" + !StringUtils.isEmpty( params.get("serialNo") ) );
//    	logger.info("++++ refDocNo ::" + !StringUtils.isEmpty( params.get("refDocNo") ) );
//    	logger.info("++++ ordNo ::" + !StringUtils.isEmpty( params.get("ordNo") ) );

    	if( !StringUtils.isEmpty( params.get("serialNo") ) ||
    			!StringUtils.isEmpty( params.get("refDocNo") ) ||
    			!StringUtils.isEmpty( params.get("ordNo") ) ){
//    		logger.info("++++ A ::");
    		params.put("startCrtDt", "");
    		params.put("endCrtDt", "");
    	}else{
//    		logger.info("++++ B ::");
    	}

		return serialHistoryMapper.selectSerialHistoryList(params);
	}

}
