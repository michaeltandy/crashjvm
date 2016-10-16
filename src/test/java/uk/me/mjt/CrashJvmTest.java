package uk.me.mjt;

import org.junit.Test;
import static org.junit.Assert.*;

public class CrashJvmTest {

    public CrashJvmTest() {
    }

    @Test
    public void testLoadedOk() {
        assertTrue(CrashJvm.loadedOk());
    }
}