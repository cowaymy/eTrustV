/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.asDefectPart.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.asDefectPart.asDefectPartService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("asDefectPartService")
public class asDefectPartServiceImpl implements asDefectPartService {

	private static final Logger logger = LoggerFactory.getLogger(asDefectPartServiceImpl.class);

	@Resource(name = "AsDefectPartMapper")
	private asDefectPartMapper asDefectPartMapper;

	@Override
	public List<EgovMap> searchAsDefPartList(Map<String, Object> params) {
		return asDefectPartMapper.searchAsDefPartList(params);
	}

	@Override
	public EgovMap selectAsDefectPartInfo(Map<String, Object> params) {
	    return asDefectPartMapper.selectAsDefectPartInfo(params);
	}

	 @Override
	  public void addDefPart(Map<String, Object> params) {
		 logger.debug("================addDefPart - START ================");
		 logger.debug(params.toString());

		asDefectPartMapper.addDefPart(params);

	    EgovMap em = new EgovMap();
	    em.put("matCode", params.get("matCode"));

	    logger.debug("================addDefPart - END ================");
	  }

	 @Override
	  public void updateDefPart(Map<String, Object> params) {
		 logger.debug("================updateDefPart - START ================");
		 logger.debug(params.toString());

		 asDefectPartMapper.updateDefPart(params);

		 logger.debug("================updateDefPart - END ================");
	  }
}