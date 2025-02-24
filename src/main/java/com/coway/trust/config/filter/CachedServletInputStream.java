package com.coway.trust.config.filter;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import javax.servlet.ServletInputStream;

public class CachedServletInputStream extends ServletInputStream {
    private ByteArrayInputStream input;

    public CachedServletInputStream(byte[] byteArray) {
        input = new ByteArrayInputStream(byteArray);
    }

    @Override
    public int read() throws IOException {
        return input.read();
    }
}