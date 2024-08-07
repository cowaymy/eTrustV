/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.design.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.design.ArtworkRequestService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("artwork")
public class ArtworkRequestServiceImpl extends EgovAbstractServiceImpl implements ArtworkRequestService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "artworkMapper")
	private ArtworkRequestMapper artwork;
	@Override
	public List<EgovMap> selectArtworkCategoryList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return artwork.selectArtworkCategoryList(params);
	}
	@Override
	public List<EgovMap> selectArtworkList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return artwork.selectArtworkList(params);
	}

	
}
