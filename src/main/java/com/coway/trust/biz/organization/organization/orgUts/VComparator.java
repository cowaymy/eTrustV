package com.coway.trust.biz.organization.organization.orgUts;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.Comparator;


public class VComparator implements Comparator<EgovMap>{
	
	@Override
	public   int compare(EgovMap o1, EgovMap o2) {
	    if ( Integer.parseInt((String)o1.get("ct") )   < Integer.parseInt((String)o2.get("ct") ) ) {
	    	
	        return -1;
	        
	    }else  if ( Integer.parseInt((String)o1.get("ct") ) >Integer.parseInt((String)o2.get("ct") ) ) {
	        return 1;
	    }
	    return 0;
	}
}
