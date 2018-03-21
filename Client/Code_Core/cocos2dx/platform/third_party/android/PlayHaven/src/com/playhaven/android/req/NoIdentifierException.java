package com.playhaven.android.req;

import com.playhaven.android.PlayHavenException;

import java.util.Set;

public class NoIdentifierException
extends PlayHavenException
{
    private static final long serialVersionUID = 3542171103303118033L;

    private static final String message = "No available identifiers were found.";
    private Set<Identifier> requested, used;

    /**
     * Constructs a new {@code PlayHavenException} with its stack trace and message filled in.
     */
    public NoIdentifierException(Set<Identifier> requested, Set<Identifier> used)
    {
        super(message);
        this.requested = requested;
        this.used = used;
    }

    public Set<Identifier> getRequestedIdentifiers(){return requested;}
    public Set<Identifier> getUsedIdentifiers(){return used;}
}
