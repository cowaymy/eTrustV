/**
 * @author Adrian C.
 **/
package com.coway.trust.biz.logistics.seriallocation.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.seriallocation.SerialLocationService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("SerialLocationService")
public class SerialLocationServiceImpl implements SerialLocationService
{

	private static final Logger logger = LoggerFactory.getLogger(SerialLocationServiceImpl.class);

	@Resource(name = "SerialLocationMapper")
	private SerialLocationMapper serialLocationMapper;

	@Override
	public List<EgovMap> searchSerialLocationList(Map<String, Object> params)
	{
		// TODO Auto-generated method stub
		return serialLocationMapper.searchSerialLocationList(params);
	}

	@Override
	public void updateItemGrade(Map<String, Object> params)
	{
		List<Object> gradeList = (List<Object>) params.get("itemGrades");

    		if (gradeList.size() > 0)
    		{
    			for (int i = 0; i < gradeList.size(); i++)
    			{
    				Map<String, Object> insertGrade = null;

    				insertGrade = (Map<String, Object>) gradeList.get(i);

    				serialLocationMapper.updateItemGrade(insertGrade);
    			}
    		}
	}

}