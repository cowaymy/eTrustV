/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serialmgmt.SerialMgmtService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SerialMgmtService")
public class SerialMgmtServiceImpl implements SerialMgmtService
{

	private static final Logger logger = LoggerFactory.getLogger(SerialMgmtServiceImpl.class);

	@Resource(name = "SerialMgmtMapper")
	private SerialMgmtMapper serialMgmtMapper;

	@Override
	public List<EgovMap> selectDeliveryBalance(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialMgmtMapper.selectDeliveryBalance(params);
	}

	@Override
	public List<EgovMap> selectGIRDCBalance(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialMgmtMapper.selectGIRDCBalance(params);
	}

	@Override
	public List<EgovMap> selectDeliveryList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialMgmtMapper.selectDeliveryList(params);
	}

	@Override
	public List<EgovMap> selectSerialDetails(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialMgmtMapper.selectSerialDetails(params);
	}

	@Override
	public List<EgovMap> selectRDCScanList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialMgmtMapper.selectRDCScanList(params);
	}

	@Override
	public List<EgovMap> selectScanList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialMgmtMapper.selectScanList(params);
	}

	@Override
	public List<EgovMap> selectBoxNoList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialMgmtMapper.selectBoxNoList(params);
	}

	@Override
	public List<EgovMap> selectUserDetails(int brnchid)
	{
		// TODO Auto-generated method stub
		return serialMgmtMapper.selectUserDetails(brnchid);
	}

	@Override
	public void insertScanItems(Map<String, Object> params) {

		List<Object> serialList = (List<Object>) params.get("scanItems");
		int scanType = Integer.parseInt(params.get("scantype").toString());
		String seq;


		if (scanType == 30)
		{
    	    seq = serialMgmtMapper.selectScanNoSeq();

    		if (serialList.size() > 0)
    		{
    			for (int i = 0; i < serialList.size(); i++)
    			{
    				Map<String, Object> insertSerial = null;

    				insertSerial = (Map<String, Object>) serialList.get(i);
    				insertSerial.put("scanno", seq);
    				insertSerial.put("scanstus", "N");
    				insertSerial.put("reqstno", params.get("reqstno"));
    				insertSerial.put("reqstdt", params.get("reqstdt"));
    				insertSerial.put("frmlocid", params.get("frmlocid"));
    				insertSerial.put("tolocid", params.get("tolocid"));
    				insertSerial.put("scantype", params.get("scantype"));
    				insertSerial.put("userid", params.get("userid"));

    				serialMgmtMapper.insertScanItems(insertSerial);
    			}
    		}
		}
		else
		{
    		seq = serialMgmtMapper.checkScanNoSeq(params.get("reqstno").toString());

    		if (seq == null){ seq = serialMgmtMapper.selectScanNoSeq(); }

    		if (serialList.size() > 0)
    		{
    			for (int i = 0; i < serialList.size(); i++)
    			{
    				Map<String, Object> insertSerial = null;

    				insertSerial = (Map<String, Object>) serialList.get(i);
    				insertSerial.put("scanno", seq);
    				insertSerial.put("scanstus", "N");
    				insertSerial.put("reqstno", params.get("reqstno"));
    				insertSerial.put("reqstdt", params.get("reqstdt"));
    				insertSerial.put("frmlocid", params.get("frmlocid"));
    				insertSerial.put("tolocid", params.get("tolocid"));
    				insertSerial.put("scantype", params.get("scantype"));
    				insertSerial.put("userid", params.get("userid"));

    				serialMgmtMapper.insertScanItems(insertSerial);
    			}
    		}
	    }
	}

}