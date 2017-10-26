package com.coway.trust.biz.logistics.roommanage.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.roommanage.RoomManagementService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("roomManagementService")
public class RoomManagementServiceImpl extends EgovAbstractServiceImpl implements RoomManagementService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "roomManagementMapper")
	private RoomManagementMapper roomManagementMapper;

	@Override
	public List<EgovMap> roomManagementList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return roomManagementMapper.roomManagementList(params);
	}
}
