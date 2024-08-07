package com.coway.trust.util;

import java.io.UnsupportedEncodingException;
import java.util.Date;

import com.coway.trust.AppConstants;

public final class ValidUtils
{
	private ValidUtils(){}
	
    /**
     * @param val 문자열 값
     * @param length 기준길이
     * @return
     */
    public static boolean isValidLimit( String val, int length )
    {
        if ( val == null )
        {
            return true;
        }
        byte[] strbytes = null;
        try
        {
            strbytes = val.getBytes( AppConstants.DEFAULT_CHARSET );
        }
        catch ( UnsupportedEncodingException e )
        {
            strbytes = val.getBytes();
        }
        if ( strbytes.length > length )
        {
            return false;
        }
        return true;
    }

    /**
     * @param val 날짜 값
     * @return
     */
    public static boolean isFuture( Date val )
    {
        if ( val == null )
        {
            return true;
        }
        if ( val.getTime() > System.currentTimeMillis() )
        {
            return true;
        }
        return false;
    }
}
