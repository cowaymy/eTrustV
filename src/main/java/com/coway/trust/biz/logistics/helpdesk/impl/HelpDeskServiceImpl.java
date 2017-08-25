/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.helpdesk.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.helpdesk.HelpDeskService;
import com.coway.trust.biz.logistics.sirim.SirimService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HelpDeskService")
public class HelpDeskServiceImpl extends EgovAbstractServiceImpl implements HelpDeskService {

	private static final Logger Logger = LoggerFactory.getLogger(HelpDeskServiceImpl.class);

	@Resource(name = "HelpDeskMapper")
	private HelpDeskMapper HelpDeskMapper;


	@Override
	public List<EgovMap> selectDataChangeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HelpDeskMapper.selectDataChangeList(params);
	}
	
	@Override
	public List<EgovMap> detailDataChangeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return HelpDeskMapper.detailDataChangeList(params);
	}
	
	


}
